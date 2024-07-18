extends CharacterBody3D

static var right_dir = Vector3(1, 0, 0)
static var up_dir = Vector3(0, 0, -1)

@onready var nav_agent = $NavigationAgent3D
@onready var collision_shape = $CollisionShape3D

# movement
var speed = 13
var target = Vector3.ZERO

@export var step_time = 0.35
var prev_time = 0


func on_ready():
	collision_shape.connect("area_shape_entered", on_hit)


func on_hit():
	print("Collision detected!")


func get_direction(delta):
	var new_direction = Vector3()

	prev_time += delta
	if (prev_time < step_time):
		return new_direction
		
	prev_time -= step_time
			
	if !nav_agent.is_target_reached():
		var cur_location = global_transform.origin
		var next_location = nav_agent.get_next_path_position()
		new_direction = next_location - cur_location

		if new_direction != Vector3.ZERO:
			new_direction = new_direction.normalized()
			
			var v_vector = new_direction.project(up_dir)
			var h_vector = new_direction.project(right_dir)
			
			if (h_vector.length_squared() > v_vector.length_squared()):
				new_direction = h_vector.normalized()
			else:
				new_direction = v_vector.normalized()

	return new_direction


func update_target(_target):
	target = _target
	nav_agent.set_target_position(target)


func _physics_process(delta):
	var direction = get_direction(delta)

	velocity = direction * speed / delta
	move_and_slide()
