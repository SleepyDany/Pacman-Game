extends Node3D

@onready var pacman = $Pacman
@onready var hud = $UI/HUD
@onready var center = $SpawnPoints/Center


func _ready():
	hud.connect("on_start", start_game)
	hud.connect("on_exit", exit)
	
	pacman.on_damage.connect(handle_pacman_damage)
	pacman.on_dead.connect(stop_game)


func _physics_process(_delta):
	get_tree().call_group("Ghosts", "update_target", pacman.global_position)


func start_game():
	if pacman.health == 0:
		hud.game_over_label.hide()
	pacman.start(null, true)
	get_tree().call_group("Ghosts", "start")


func stop_game():
	pacman.stop()
	get_tree().call_group("Ghosts", "stop")
	hud.show()
	hud.game_over_label.show()


func handle_pacman_damage(player_health):
	if (player_health > 0):
		var spawn_points = get_tree().get_nodes_in_group("SpawnPoints")
		var index = randi() % spawn_points.size()
		
		pacman.stop()
		pacman.start(spawn_points[index].global_position)


func exit():
	queue_free()
