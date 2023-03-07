extends RigidBody2D

const SPEED = 600.0
@onready var timer = $Timer

func _process(_delta):
	if timer.time_left / timer.wait_time < 0.25:
		$Sprite2D.modulate.a = timer.time_left / timer.wait_time

func _on_timer_timeout():
	queue_free()

func fire(angle: float) -> void:
	linear_velocity = Vector2.UP.rotated(angle) * SPEED
