extends Node2D

var scene_lines = []
var scene_index := 0
var current_scene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Textbox.hide()
	$MainMenuButton.connect("pressed", Global._on_main_menu_button_pressed)
	current_scene = "res://visual_novel/assets/scene-test-1.txt"
	load_scene(current_scene)
	parse_current_line()
	
func load_scene(res:String):
	var file = FileAccess.open(res, FileAccess.READ)
	var content = file.get_as_text()
	var lines = content.split("\n")
	scene_lines = []
	for line in lines:
		if line != "\n" and line != "":
			scene_lines.append(line.strip_edges())
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		next_line()
		
	if event.is_action_pressed("visual_novel_debug_reload_script"):
		load_scene(current_scene)
		parse_current_line()
		print_debug("scene %s reloaded" % current_scene)

func next_line():
	scene_index += 1
	if scene_index >= scene_lines.size():
		scene_index = 0
	parse_current_line()

var current_speaker = null

func parse_current_line():
	var line := scene_lines[scene_index] as String
	
	if line.find("!") == 0:
		run_command(line)
	else:
		render_dialogue(line)
		
func run_command(line:String):
	var parts = line.split(" ")
	var command = parts[0]
	var args = parts.slice(1)
	match command:
		"!bg":
			$BGSprite.texture = load("res://visual_novel/assets/bg-%s.png" % args[0])
			$BGSprite.show()
		"!clear_bg":
			$BGSprite.texture = null
			$BGSprite.hide()
		_:
			push_warning("command not supported: %s" % command)
	
	next_line()

func render_dialogue(line:String):
	if !$Textbox.visible:
		$Textbox.show()
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
	text = text.strip_edges()
	$Textbox/Text.text = text
