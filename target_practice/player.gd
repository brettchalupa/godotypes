extends CharacterBody3D

const MAX_SPEED_HORIZ = 60.0
const MAX_SPEED_VERT = 80.0
const DECEL = 2000.0
const ACCEL = 4000.0
const ACCEL_VERT = 2000.0
const ACCEL_HORIZ = 3000.0
const BULLET_SPEED = 160.0

@export var bullet_scene:PackedScene

func _physics_process(delta: float) -> void:
	var direction := Vector3.ZERO
	direction.z = Input.get_axis("ui_left", "ui_right")
	direction.y = Input.get_axis("ui_down", "ui_up")
	direction = direction.normalized()

	if direction.z > 0:
		velocity.z = move_toward(velocity.z, MAX_SPEED_HORIZ, delta * ACCEL_HORIZ)
	elif direction.z < 0:
		velocity.z = move_toward(velocity.z, -MAX_SPEED_HORIZ, delta * ACCEL_HORIZ)
	else:
		velocity.z = move_toward(velocity.z, 0, delta * DECEL)

	if direction.y > 0:
		velocity.y = move_toward(velocity.y, MAX_SPEED_VERT, delta * ACCEL_VERT)
	elif direction.y < 0:
		velocity.y = move_toward(velocity.y, -MAX_SPEED_VERT, delta * ACCEL_VERT)
	else:
		velocity.y = move_toward(velocity.y, 0, delta * DECEL)

	move_and_slide()
	

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		_fire_weapon()

func _fire_weapon():
	var bullet = bullet_scene.instantiate()

	bullet.linear_velocity = Vector3(0, 0, BULLET_SPEED)
	get_tree().get_root().add_child(bullet)
	bullet.global_position = global_position
	Sound.play_sfx($BlastSfx)
