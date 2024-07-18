extends Node3D

@onready var pacman = $Pacman

func _physics_process(_delta):
	get_tree().call_group("Ghosts", "update_target", pacman.global_transform.origin)
