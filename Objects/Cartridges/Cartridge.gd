extends RigidBody2D
class_name Cartridge

enum MODES {DEFAULT, JUMP, PUSH, SPEED}
@export var mode: MODES

func _ready():
	match mode:
		MODES.JUMP:
			$Sprite2D.texture = load("res://Assets/Cartridge/JumpCartridge.png")
		MODES.PUSH:
			$Sprite2D.texture = load("res://Assets/Cartridge/PushCartridge.png")
		MODES.SPEED:
			$Sprite2D.texture = load("res://Assets/Cartridge/SpeedCartridge.png")

func _on_area_2d_body_entered(body):
	if body is Player:
		body.addCartridge(mode)
		queue_free()
