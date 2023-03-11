extends Node2D

func _ready() -> void:
	$HUD/MainMenuButton.connect("pressed", Global._on_main_menu_button_pressed)
