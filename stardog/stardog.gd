extends Node3D

func _ready() -> void:
	$UI/MainMenuButton.connect("pressed", Global._on_main_menu_button_pressed)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("debug_reset_scene"):
		get_tree().reload_current_scene.call_deferred()
