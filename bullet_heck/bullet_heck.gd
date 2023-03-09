extends Node2D

var game_over = false
@onready var player = $Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$MainMenuButton.connect("pressed", Global._on_main_menu_button_pressed)
	set_hp()

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
