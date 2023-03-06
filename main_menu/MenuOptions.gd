extends VFlowContainer

@export var settings_scene:PackedScene

func _ready():	
	if !OS.has_feature("pc"):
		$Quit.hide()

func _on_quit_pressed():
	get_tree().quit()

func _on_settings_pressed():
	get_tree().change_scene_to_packed(settings_scene)
