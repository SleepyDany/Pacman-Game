extends Node3D

@onready var npc = $Npc_dev
var mouse_viewport_pos = Vector2()
var mouse_space_pos = Vector3()

func _input(event):
	if event is InputEventMouseButton && event.is_pressed():
		mouse_viewport_pos = event.position
		mouse_space_pos = find_space_pos()
		npc.update_target_position(mouse_space_pos)
		
func find_space_pos():
	var world_space = get_world_3d().direct_space_state
	var camera = get_tree().root.get_camera_3d()
	
	var ray_origin = camera.project_ray_origin(mouse_viewport_pos)
	var ray_end = camera.project_position(mouse_viewport_pos, 1000)
	
	var result = world_space.intersect_ray(PhysicsRayQueryParameters3D.create(ray_origin, ray_end))
	
	return result["position"] if result.has("position") else ray_end
	
