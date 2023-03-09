extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$MainMenuButton.connect("pressed", Global._on_main_menu_button_pressed)
