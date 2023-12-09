extends CharacterBody2D
class_name Player

signal cartridgeSig

var SPEED = 300.0
var JUMP_VELOCITY = -400.0


# Eri modet enumina
enum MODES {DEFAULT, JUMP, PUSH, SPEED}
var mode: MODES = MODES.DEFAULT

# Kasettien määrät
var cartridges_dict = {MODES.JUMP: 0, MODES.PUSH: 0, MODES.SPEED: 1}


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var animation = get_node("AnimationPlayer")
@onready var sprite = get_node("AnimatedSprite2D")

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction == 1:
		velocity.x = direction * SPEED
		sprite.flip_h = false
		animation.play("Walk")
	elif direction == -1:
		velocity.x = direction * SPEED
		sprite.flip_h = true
		animation.play("Walk")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		animation.play("Idle")
	

	move_and_slide()

func _input(event):
	if event.is_action_pressed("MODE_JUMP") && cartridges_dict[MODES.JUMP] > 0:
		removeCartridge(MODES.JUMP)
		changeMode(MODES.JUMP)
	elif event.is_action_pressed("MODE_SPEED") && cartridges_dict[MODES.SPEED] > 0:
		removeCartridge(MODES.SPEED)
		changeMode(MODES.SPEED)

func changeMode(mode: MODES):
	match mode:
		MODES.DEFAULT:
			mode = MODES.DEFAULT
			SPEED = 300.0
			JUMP_VELOCITY = -400.0
		MODES.JUMP:
			mode = MODES.JUMP
			SPEED = 300.0
			JUMP_VELOCITY = -800.0
		MODES.SPEED:
			mode = MODES.SPEED
			SPEED = 600.0
			JUMP_VELOCITY = -400.0
		_:
			mode = MODES.DEFAULT
			SPEED = 300.0
			JUMP_VELOCITY = -400.0

func addCartridge(mode: MODES):
	cartridges_dict[mode] = cartridges_dict[mode] + 1
	cartridgeSig.emit()
	
func removeCartridge(mode: MODES):
	cartridges_dict[mode] = cartridges_dict[mode] - 1
	cartridgeSig.emit()
