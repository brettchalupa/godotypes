extends CharacterBody2D

const SPEED = 600.0
@onready var timer = $Timer

func _process(_delta):
	if timer.time_left / timer.wait_time < 0.25:
		$Sprite2D.modulate.a = timer.time_left / timer.wait_time

func fire(rot):
	rotation = rot
	velocity = Vector2.UP.rotated(rotation) * SPEED
	
func _on_timer_timeout():
	queue_free()

func _physics_process(_delta):
	velocity = Vector2.UP.rotated(rotation) * SPEED
	move_and_slide()
