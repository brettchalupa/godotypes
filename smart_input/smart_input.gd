extends Node2D

enum ACTIVE_INPUTS {
	KEYBOARD,
	JOYPAD,
}
var active_input = ACTIVE_INPUTS.KEYBOARD

func _on_main_menu_button_pressed():
	get_tree().change_scene_to_file("res://main_menu/main_menu.tscn")

func _input(event):
	if active_input != ACTIVE_INPUTS.KEYBOARD and event.get_class() == "InputEventKey":
		active_input = ACTIVE_INPUTS.KEYBOARD
		display_input_aware_controls()
	elif active_input != ACTIVE_INPUTS.JOYPAD and event.get_class().contains("InputEventJoypad"):
		active_input = ACTIVE_INPUTS.JOYPAD
		display_input_aware_controls()

	if event.is_action_pressed("pause"):
		get_tree().change_scene_to_file("res://main_menu/main_menu.tscn")

func _ready():
	check_for_active_input()
	Input.connect("joy_connection_changed", _on_joy_connection_changed)

func display_input_aware_controls():
	if active_input == ACTIVE_INPUTS.JOYPAD:
		get_tree().call_group("control-keyboard", "hide")
		get_tree().call_group("control-joypad", "show")
	else:
		get_tree().call_group("control-keyboard", "show")
		get_tree().call_group("control-joypad", "hide")

func _on_joy_connection_changed(device_id, connected):
	check_for_active_input()

func check_for_active_input():
	var last_input = active_input
	if Input.get_connected_joypads().size() > 0:
		active_input = ACTIVE_INPUTS.JOYPAD
	else:
		active_input = ACTIVE_INPUTS.KEYBOARD
	
	if last_input != active_input:
		display_input_aware_controls()
