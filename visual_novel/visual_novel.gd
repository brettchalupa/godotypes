extends Node2D

var dialogue_lines = []
var dialogue_index := 0
var current_scene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$MainMenuButton.connect("pressed", Global._on_main_menu_button_pressed)
	current_scene = "res://visual_novel/assets/scene-test-1.txt"
	load_scene(current_scene)
	render_current_dialogue()
	
func load_scene(res:String):
	var file = FileAccess.open(res, FileAccess.READ)
	var content = file.get_as_text()
	var lines = content.split("\n")
	dialogue_lines = []
	for line in lines:
		print_debug(line)
		if line != "\n" and line != "":
			dialogue_lines.append(line.strip_edges())
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		next_line()
		
	if event.is_action_pressed("visual_novel_debug_reload_script"):
		load_scene(current_scene)
		render_current_dialogue()
		print_debug("scene %s reloaded" % current_scene)

func next_line():
	dialogue_index += 1
	if dialogue_index >= dialogue_lines.size():
		dialogue_index = 0
	render_current_dialogue()

var current_speaker = null

func render_current_dialogue():
	var line := dialogue_lines[dialogue_index] as String
	var line_parts := line.split(":", true, 1)
	var text:String
	if line_parts.size() > 1:
		var speaker = line_parts[0].strip_edges()
		if current_speaker != speaker:
			$Textbox/SpeakerSprite.texture = load("res://visual_novel/assets/%s.png" % speaker.to_lower().replace(" ", "-"))
			$Textbox/SpeakerSprite.show()
			current_speaker = speaker
		$Textbox/Speaker.text = speaker
		$Textbox/SpeakerBG.show()
		text = line_parts[1]
	else:
		$Textbox/Speaker.text = ""
		$Textbox/SpeakerBG.hide()
		$Textbox/SpeakerSprite.hide()
		current_speaker = null
		text = line_parts[0]
	print_debug(text)
	text = text.strip_edges()
	$Textbox/Text.text = text
