extends RigidBody2D
class_name Cartridge

enum MODES {DEFAULT, JUMP, PUSH, SPEED}
var mode: MODES = MODES.JUMP

func _on_body_entered(body):
	print(body)
	if body is Player:
		body.addCatrdidge(mode)
		queue_free()
