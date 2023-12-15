extends CharacterBody2D
class_name Player

signal cartridgeSig

var SPEED = 300.0
var JUMP_VELOCITY = -400.0
var pushing = true
var crate: Crate = null
var push_force = 80

# Eri modet enumina
enum MODES {DEFAULT, JUMP, PUSH, SPEED}
var mode: MODES = MODES.DEFAULT

# Kasettien määrät
var cartridges_dict = {MODES.JUMP: 0, MODES.PUSH: 1, MODES.SPEED: 1}

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var lastDirection = 1

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
		lastDirection = direction
		$AnimationPlayer.play("run")
		$leftAnimation.hide()
		$rightAnimation.show()
		velocity.x = direction * SPEED
		$Area2D/CollisionShape2D.position = Vector2(8,32)
	elif direction == -1:
		lastDirection = direction
		$AnimationPlayer.play("inverse_run")
		$rightAnimation.hide()
		$leftAnimation.show()
		velocity.x = direction * SPEED
		$Area2D/CollisionShape2D.position = Vector2(-8,32)
	else:
		if lastDirection == 1:
			$AnimationPlayer.play("idle")
			$leftAnimation.hide()
			$rightAnimation.show()
		else:
			$AnimationPlayer.play("inverse_idle")
			$rightAnimation.hide()
			$leftAnimation.show()
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	

	move_and_slide()
	
	if pushing:
		for i in get_slide_collision_count():
			var c = get_slide_collision(i)
			if c.get_collider() is Crate:
				c.get_collider().apply_central_impulse(-c.get_normal() * 80)

func _input(event):
	if event.is_action_pressed("MODE_JUMP") && cartridges_dict[MODES.JUMP] > 0:
		removeCartridge(MODES.JUMP)
		changeMode(MODES.JUMP)
	elif event.is_action_pressed("MODE_SPEED") && cartridges_dict[MODES.SPEED] > 0:
		removeCartridge(MODES.SPEED)
		changeMode(MODES.SPEED)
		print(mode)
	elif event.is_action_pressed("MODE_PUSH") && cartridges_dict[MODES.PUSH] > 0:
		removeCartridge(MODES.PUSH)
		changeMode(MODES.PUSH)
		print(mode)
	elif event.is_action_pressed("Interact") && crate != null && is_on_floor():
		print(mode)
		print("Painettu")
		_grab_crate()
	elif event.is_action_released("Interact"):
		print("Päästetty")
		_release_crate()

func changeMode(mode: MODES):
	match mode:
		MODES.DEFAULT:
			mode = MODES.DEFAULT
			SPEED = 300.0
			JUMP_VELOCITY = -400.0
			pushing = false
		MODES.JUMP:
			mode = MODES.JUMP
			SPEED = 300.0
			JUMP_VELOCITY = -800.0
			pushing = false
		MODES.SPEED:
			mode = MODES.SPEED
			SPEED = 600.0
			JUMP_VELOCITY = -400.0
			pushing = false
		MODES.PUSH:
			mode = MODES.PUSH
			print("Modehan on siis " , mode)
			SPEED = 300.0
			JUMP_VELOCITY = -400.0
			pushing = true
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

func _on_area_2d_body_entered(body):
	if body is Crate:
		print("LAATIKKO HAVAITTU")
		crate = body

func _on_area_2d_body_exited(body):
	if body is Crate:
		crate = null

func _grab_crate():
	print("Napataan")
	SPEED = 150
	JUMP_VELOCITY = -200.0
	pushing = true
	#crate.set_lock_rotation(true)
	var cratepath = crate.get_path()
	$GrooveJoint2D.set_node_a($".".get_path())
	$GrooveJoint2D.set_node_b(cratepath)
	
func _release_crate():
	print("Päästetään")
	SPEED = 300.0
	JUMP_VELOCITY = -400.0
	pushing = false
	#crate.set_lock_rotation(false)
	$GrooveJoint2D.set_node_a('')
	$GrooveJoint2D.set_node_b('')
