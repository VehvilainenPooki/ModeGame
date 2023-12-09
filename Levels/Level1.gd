extends Node2D

@export var player: Player
@export var toolbar: ToolBar
# Called when the node enters the scene tree for the first time.
func _ready():
	if !player.cartridgeSig.is_connected(toolbar.update_cartridges):
		player.cartridgeSig.connect(toolbar.update_cartridges)

func _input(event):
	if event.is_action_pressed("Reset"):
		get_tree().reload_current_scene()

