extends Node2D

var game_over = false
@onready var player = $Player
enum ACTIVE_INPUTS {
	KEYBOARD,
	JOYPAD,
}
var active_input = ACTIVE_INPUTS.KEYBOARD
var active_joypad

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$MainMenuButton.connect("pressed", Global._on_main_menu_button_pressed)
	set_hp()
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
		active_input = ACTIVE_INPUTS.JOYPAD
	else:
		active_input = ACTIVE_INPUTS.KEYBOARD
	
	if last_input != active_input:
		display_input_aware_controls()

func set_hp() -> void:
	$UI/PlayerHealthBar.max_value = player.max_health
	$UI/PlayerHealthBar.value = player.health
	$UI/PlayerHealth.text = "HP: " + str(player.health)

func _on_player_died() -> void:
	$GameOver/GameOverTimer.start()

func _on_won() -> void:
	$Won/WonTimer.start()

func _input(event: InputEvent) -> void:
	if game_over and event.is_action_pressed("ui_accept"):
		get_tree().reload_current_scene.call_deferred()

	if active_input != ACTIVE_INPUTS.KEYBOARD and event.get_class() == "InputEventKey":
		active_input = ACTIVE_INPUTS.KEYBOARD
		display_input_aware_controls()
	elif active_input != ACTIVE_INPUTS.JOYPAD and event.get_class().contains("InputEventJoypad"):
		active_input = ACTIVE_INPUTS.JOYPAD
		display_input_aware_controls()

func _on_game_over_timer_timeout() -> void:
	game_over = true
	$GameOver.show()

func _on_won_timer_timeout() -> void:
	game_over = true
	$Won.show()

func _on_player_damaged(_new_health) -> void:
	set_hp()

func _on_enemy_spawner_wave_started(wave) -> void:
	$UI/Wave.text = "Wave: " + str(wave)
