extends CanvasLayer

signal on_start()
signal on_exit()

@onready var menu = $Menu
@onready var start_btn = $Menu/StartButton
@onready var exit_btn = $Menu/ExitButton
@onready var game_over_label = $Menu/GameOverLabel


func _ready():
	start_btn.connect("pressed", start)
	exit_btn.connect("pressed", exit)


func _input(event):
	if event.is_action_pressed("ui_cancel"):
		self.visible = !self.visible


func start():
	self.hide()
	on_start.emit()


func exit():
	on_exit.emit()
