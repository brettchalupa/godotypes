extends Area2D

signal collected

@onready var sfx = $Sfx

func _on_body_entered(_body: Node2D) -> void:
	collected.emit()
	hide()

	if Sound.play_sfx(sfx):
		sfx.connect("finished", queue_free)
	else:
		queue_free()
