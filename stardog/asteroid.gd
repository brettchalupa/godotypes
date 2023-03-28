extends RigidBody3D

func _physics_process(delta: float) -> void:
	for collider in get_colliding_bodies():
		print_debug(collider)

func _on_body_entered(body: Node) -> void:
	print_debug(body)
