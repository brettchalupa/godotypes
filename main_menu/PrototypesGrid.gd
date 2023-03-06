extends GridContainer

func _ready():
	get_children()[0].grab_focus()


func _on_smart_input_button_pressed():
	get_tree().change_scene_to_file("res://smart_input/smart_input.tscn")
