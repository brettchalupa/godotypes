extends Node2D

var game_over = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$MainMenuButton.connect("pressed", Global._on_main_menu_button_pressed)

func _on_player_died() -> void:
	$GameOver/GameOverTimer.start()

func _input(event: InputEvent) -> void:
	if game_over and event.is_action_pressed("ui_accept"):
		get_tree().reload_current_scene.call_deferred()

func _on_game_over_timer_timeout() -> void:
	game_over = true
	$GameOver.show()
