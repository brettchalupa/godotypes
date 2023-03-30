extends Node3D

func _ready() -> void:
	$UI/MainMenuButton.connect("pressed", Global._on_main_menu_button_pressed)
