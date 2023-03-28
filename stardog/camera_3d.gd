extends Camera3D

@onready var player:CharacterBody3D = get_parent().get_node("Player")

@export var distance_from_player = 10

func _process(_delta: float) -> void:
	position.z = player.position.z - distance_from_player
