extends Area3D

func _on_body_entered(body: Node3D) -> void:
	if body.has_method("hit"):
		body.hit()
	Sound.play_sfx($ExplosionSfx)
