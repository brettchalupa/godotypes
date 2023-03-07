extends GridContainer

func _ready():
	get_children()[0].grab_focus()

func _on_game_button_pressed(game):
	get_tree().change_scene_to_file("res://%s/%s.tscn" % [game, game])
