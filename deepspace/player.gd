extends CharacterBody3D

const MAX_SPEED_HORIZ = 250.0
const MAX_SPEED_VERT = 150.0
const DECEL = 2600.0
const ACCEL = 4200.0
const ACCEL_VERT = 2400.0
const ACCEL_HORIZ = 3200.0

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
	
