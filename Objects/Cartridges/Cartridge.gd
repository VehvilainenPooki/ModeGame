extends RigidBody2D
class_name Cartridge

enum MODES {DEFAULT, JUMP, PUSH, SPEED}
@export var mode: MODES

func _on_area_2d_body_entered(body):
	if body is Player:
		body.addCartridge(mode)
		queue_free()
