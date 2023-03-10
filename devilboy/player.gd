extends CharacterBody2D

const SPEED = 200.0
const JUMP_VELOCITY = -340.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var sprite = $AnimatedSprite2D
@onready var jump_sfx = $JumpSfx

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		Sound.play_sfx(jump_sfx)

	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED

		if direction > 0:
			sprite.flip_h = false
		else:
			sprite.flip_h = true
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	if not is_on_floor():
		sprite.play("jump")
	else:
		if velocity.x == 0:
			sprite.play("idle")
		else:
			sprite.play("run")

	move_and_slide()
