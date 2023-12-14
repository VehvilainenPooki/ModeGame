extends RigidBody2D
class_name Crate

var player: Player
var moving: bool
enum MODES {DEFAULT, JUMP, PUSH, SPEED}

# Called when the node enters the scene tree for the first time.
func _ready():
	moving = false

func _on_area_2d_body_entered(body):
	if body is Player and body.pushing:
		player = body
		moving = true
		$".".apply_impulse(Vector2(0,0))
		#print(moving)

func _on_area_2d_body_exited(body):
	if body is Player:
		moving = false
		#print(moving)


func _integrate_forces(state):
	if moving:
		#print("jou")
		#state.apply_central_force(Vector2(1000,-10))
		pass

