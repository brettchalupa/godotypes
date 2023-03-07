extends Node2D

enum ACTIVE_INPUTS {
	KEYBOARD,
	JOYPAD,
}
var active_input = ACTIVE_INPUTS.KEYBOARD
var active_joypad

func _on_main_menu_button_pressed():
	get_tree().change_scene_to_file("res://main_menu/main_menu.tscn")

func _input(event):
	if active_input != ACTIVE_INPUTS.KEYBOARD and event.get_class() == "InputEventKey":
		active_input = ACTIVE_INPUTS.KEYBOARD
		display_input_aware_controls()
	elif active_input != ACTIVE_INPUTS.JOYPAD and event.get_class().contains("InputEventJoypad"):
		active_input = ACTIVE_INPUTS.JOYPAD
		display_input_aware_controls()

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
	if connected:
		active_joypad = device_id
	check_for_active_input()

func check_for_active_input():
	var last_input = active_input
	if Input.get_connected_joypads().size() > 0:
		if active_joypad == null:
			active_joypad = 0
		$ConnectedController.text = "Controller: " + Input.get_joy_name(active_joypad)
		$ConnectedController.show()
		active_input = ACTIVE_INPUTS.JOYPAD
	else:
		$ConnectedController.hide()
		active_input = ACTIVE_INPUTS.KEYBOARD
	
	if last_input != active_input:
		display_input_aware_controls()
