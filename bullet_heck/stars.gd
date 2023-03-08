extends Node

@export var field:ColorRect
const MARGIN = 10

func _ready() -> void:
	for star in get_children():
		set_random_props(star)

func set_random_props(star:Node):
	star.set_meta("speed", randi_range(80, 120))
	star.modulate.a = randf_range(0.15, 0.5)

func _process(delta: float) -> void:
	for star in get_children():
		var speed = star.get_meta("speed")
		star.position += Vector2(0, speed * delta)
		if star.position.y >= field.position.y + field.size.y:
			star.position = Vector2(
				randi_range(field.position.x + MARGIN, field.position.x + field.size.x - MARGIN),
				randi_range(-4, -80)
			)
			set_random_props(star)
