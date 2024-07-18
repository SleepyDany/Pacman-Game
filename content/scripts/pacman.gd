extends CharacterBody3D

@onready var mesh = $CollisionShape3D

var speed = 13
var direction = Vector3()
var b_left_turn = true
@export var step_time = 0.4
var prev_time = 0


func get_direction():
	var new_direction = Vector3.ZERO
	var b_should_flip = false

	# only one possible moving direction
	if Input.is_action_pressed("move_up"):
		new_direction.z -= 1
	elif Input.is_action_pressed("move_down"):
		new_direction.z += 1
	elif Input.is_action_pressed("move_left"):
		new_direction.x -= 1
		b_should_flip = !b_left_turn
	elif Input.is_action_pressed("move_right"):
		new_direction.x += 1
		b_should_flip = b_left_turn

	if b_should_flip:
		b_left_turn = !b_left_turn
		mesh.basis *= Basis.FLIP_Z

	return new_direction


func _physics_process(delta):
	# get direction and flip
	var new_direction = get_direction()
	if new_direction != Vector3.ZERO:
		direction = new_direction
	
 	# moving during step_time only
	prev_time += delta
	if (prev_time < step_time):
		return
	
	prev_time -= step_time
	
	# main move
	velocity = direction * speed / delta
	move_and_slide()
