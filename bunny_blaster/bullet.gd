extends Area2D

const SPEED = 300.0
const STRENGTH = 1
@onready var life_timer = $LifeTimer
var direction = 1
func fire(dir):
	direction = dir
	$Sprite2D.flip_h = direction == 0
	life_timer.start()

func _process(delta: float) -> void:
	var pos_diff = SPEED * delta
	if direction == 0: # left
		position.x -= pos_diff
	else:
		position.x += pos_diff
	
func _on_body_entered(body: Node2D) -> void:
	if body.has_method("damage"):
		body.damage(STRENGTH)
	queue_free()

func _on_life_timer_timeout() -> void:
	queue_free()


func _on_flash_timer_timeout() -> void:
	pass # Replace with function body.
