extends Node2D

var gems_collected := 0
var gems_in_level:int
var game_over = false

func _ready() -> void:
	$HUD/MainMenuButton.connect("pressed", Global._on_main_menu_button_pressed)
	gems_in_level = $TileMap/Gems.get_child_count()
	for gem in $TileMap/Gems.get_children():
		gem.connect("collected", _gem_collected)
	_update_hud()
		
func _gem_collected() -> void:
	gems_collected += 1
	_update_hud()
	
	if gems_collected >= gems_in_level:
		$HUD/GameOver.show()
		game_over = true
	
func _update_hud() -> void:
	$HUD/GemsCollected.text = str(gems_collected) + "/" + str(gems_in_level)

func _input(event: InputEvent) -> void:
	if game_over and event.is_action_pressed("ui_accept"):
		get_tree().reload_current_scene.call_deferred()
