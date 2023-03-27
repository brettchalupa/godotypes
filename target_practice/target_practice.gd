extends Node3D

func _ready() -> void:
	$MainMenuButton.connect("pressed", Global._on_main_menu_button_pressed)
