extends CharacterBody2D

const SPEED_HORIZ = 500.0
const SPEED_VERT = 400.0

@export var field:ColorRect

func _physics_process(delta: float) -> void:
	var direction := Vector2.ZERO
	direction.x = Input.get_axis("ui_left", "ui_right")
	direction.y = Input.get_axis("ui_up", "ui_down")
	direction = direction.normalized()
	if abs(direction.x) > 0:
		velocity.x = direction.x * SPEED_HORIZ
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED_HORIZ)
	if abs(direction.y) > 0:
		velocity.y = direction.y * SPEED_VERT
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED_VERT)

	move_and_slide()

	if field != null:
		position = position.clamp(field.position, field.position + field.size)
