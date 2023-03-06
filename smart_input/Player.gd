extends CharacterBody2D

@export var weapon:PackedScene

const THRUST_SPEED = 400.0
const TURN_SPEED = 4.0

func _physics_process(delta):
	rotation -= Input.get_action_strength("ui_left") * delta * TURN_SPEED
	rotation += Input.get_action_strength("ui_right") * delta * TURN_SPEED
	
	if Input.is_action_pressed("ui_up"):
		velocity = Vector2.UP.rotated(rotation) * THRUST_SPEED
	else:
		velocity = velocity.move_toward(Vector2.ZERO, delta * THRUST_SPEED)

	if Input.is_action_just_pressed("ui_accept"):
		var beam = weapon.instantiate()
		beam.global_position = global_position
		beam.fire(rotation)
		$BlastSfx.play()
		get_tree().get_root().add_child(beam)

	move_and_slide()
	position = position.clamp(Vector2.ZERO, get_viewport_rect().size)

func _process(_delta):
	pass
