extends CharacterBody3D

var right_dir = Vector3(1, 0, 0)
var up_dir = Vector3(0, 0, -1)

@onready var agent = $NavigationAgent3D
var speed = 13
var step_time = 0.35
var prev_time = 0
var target_pos = Vector3.ZERO
var move_direction = Vector3.ZERO

func _ready():
	pass

func _physics_process(delta):
	prev_time += delta
	if (prev_time < step_time):
		return
		
	prev_time -= step_time
		
	var new_direction = Vector3()
	
	if !agent.is_target_reached():
		var cur_location = global_transform.origin
		var next_location = agent.get_next_path_position()
		new_direction = next_location - cur_location
		new_direction = new_direction.normalized()
		
		var vert_vector = new_direction.project(up_dir)
		var horiz_vector = new_direction.project(right_dir)
		
		if (horiz_vector.length_squared() > vert_vector.length_squared()):
			new_direction = horiz_vector.normalized()
		else:
			new_direction = vert_vector.normalized()
		
		
		# print("Dir is {0}".format([new_direction]))
		# print("Target desired distance is {0}".format([agent.target_desired_distance]))
		# print("Distance is {0}".format([agent.target_position.distance_to(global_transform.origin)]))
		velocity = new_direction * speed / delta
		
		move_and_slide()

func update_target_position(_target):
	
	# TODO: rework through path-finding without new target setting
	var prev_target = agent.get_target_position()
	agent.set_target_position(_target)	
	print("Target {0} is reachable: {1}".format([_target, agent.is_target_reachable()]))
	
	if !agent.is_target_reachable():
		agent.set_target_position(prev_target)
