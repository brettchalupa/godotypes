extends VehicleBody3D

func _physics_process(delta: float) -> void:
	var input_dir := Input.get_vector("ui_right", "ui_left", "ui_down", "ui_up")
