extends Node2D


const DIALOGUE_LINES = [
	"Dagron:Hi, there! I'm Dagron the dragon.",
	"Dagron:What, you don't know me?",
	"Dagron:We met last week!",
	"Dagron:Oh, this is what we call a long line mate! Let's hope it wraps or something similar."
]
var dialogue_index := 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$MainMenuButton.connect("pressed", Global._on_main_menu_button_pressed)
	render_current_dialogue()
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		next_line()
func next_line():
	dialogue_index += 1
	if dialogue_index >= DIALOGUE_LINES.size():
		dialogue_index = 0
	render_current_dialogue()

func render_current_dialogue():
	var line := DIALOGUE_LINES[dialogue_index] as String
	var line_parts := line.split(":", true, 1)
	var text:String
	if line_parts.size() > 1:
		$Textbox/Speaker.text = line_parts[0]
		text = line_parts[1]
	else:
		$Textbox/Speaker.text = ""
		text = line_parts[0]
	$Textbox/Text.text = text
