extends RigidBody3D

func _on_visible_on_screen_notifier_3d_screen_exited() -> void:
	queue_free()

func hit():
	queue_free()
