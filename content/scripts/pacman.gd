extends CharacterBody3D

@onready var b_is_alive = false
@onready var mesh = $CollisionShape3D
@onready var health_bar = $HUD/HealthBar
@onready var camera = $Camera3D

signal on_damage(health)
signal on_dead()

var health = 3
var health_bar_nodes = []

var step = 13
var prev_time = 0
@export var step_time = 0.4

@export var camera_lerp_weight = 0.1
var direction = Vector3.ZERO
var input_direction = Vector3.ZERO
var b_left_turn = true


func _ready():
	for node in health_bar.get_children():
		node.visible = true


func _input(event):
	if not b_is_alive:
		return
	
	input_direction = Vector3.ZERO
	var b_should_flip = false

	# only one possible moving direction
	if event.is_action_pressed("move_up"):
		input_direction.z -= 1
	elif event.is_action_pressed("move_down"):
		input_direction.z += 1
	elif event.is_action_pressed("move_left"):
		input_direction.x -= 1
		b_should_flip = !b_left_turn
	elif event.is_action_pressed("move_right"):
		input_direction.x += 1
		b_should_flip = b_left_turn

	if b_should_flip:
		b_left_turn = !b_left_turn
		mesh.basis *= Basis.FLIP_Z


func _physics_process(delta):
	if not b_is_alive:
		return
	
	var collision = handle_movement(delta)
	handle_collision(collision)
	handle_camera()


func start(spawn_position = null, b_new_game = false):
	b_is_alive = true
	
	if spawn_position != null:
		global_position = spawn_position
	
	if b_new_game:
		health = 3
	
		for node in health_bar.get_children():
			node.visible = true


func stop():
	b_is_alive = false
	direction = Vector3.ZERO


func handle_movement(delta : float):
	if input_direction != Vector3.ZERO:
		direction = input_direction
	
	# moving during step_time only
	prev_time += delta
	if (prev_time < step_time):
		return
	
	prev_time -= step_time
	
	# main move
	velocity = direction * step
	return move_and_collide(velocity)


func handle_collision(collision):
	if not b_is_alive:
		return
		
	if collision == null or collision.get_collider() == null:
		return

	var collider = collision.get_collider()
	if collider == null or not collider.is_in_group("Ghosts"):
		return

	handle_damage(collider)


func handle_camera():
	camera.global_position.x = lerp(camera.global_position.x, global_position.x, camera_lerp_weight)
	camera.global_position.z = lerp(camera.global_position.z, global_position.z, 0.1)


func handle_damage(damage_actor: CollisionObject3D):
	if !b_is_alive or damage_actor == null or not damage_actor.is_in_group("Ghosts"):
		return

	health -= 1
	on_damage.emit(health)
	
	var heart = health_bar.get_child(health - 1)
	if heart != null:
		heart.hide()
	
	if health <= 0:
		die()


func die():
	b_is_alive = false
	on_dead.emit()
