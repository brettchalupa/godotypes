extends Node3D

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	$UI/MainMenuButton.connect("pressed", Global._on_main_menu_button_pressed)

func _input(event: InputEvent) -> void:
	if OS.is_debug_build() && event.is_action_pressed("debug_reset_scene"):
		get_tree().reload_current_scene.call_deferred()
