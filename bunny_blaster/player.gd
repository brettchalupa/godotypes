extends CharacterBody2D


const SPEED = 150.0
const JUMP_VELOCITY = -300.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var blast_sfx = $BlastSfx
@onready var sprite = $AnimatedSprite2D
enum Direction {
	LEFT,
	RIGHT
}
var direction = Direction.RIGHT
@export var bullet_scene:PackedScene

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var input_dir := Input.get_axis("ui_left", "ui_right")
	if input_dir:
		velocity.x = input_dir * SPEED	
		sprite.flip_h = input_dir < 0
		if input_dir > 0:
			direction = Direction.RIGHT
		else:
			direction = Direction.LEFT
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	var just_fired = false
	if Input.is_action_just_pressed("bunny_fire"):
		Sound.play_sfx(blast_sfx)
		just_fired = true
		var bullet = bullet_scene.instantiate()
		bullet.global_position = global_position
		bullet.position.y -= 6
		if direction == Direction.LEFT:
			bullet.position.x -= 8
		else:
			bullet.position.x += 8
		get_tree().get_root().add_child(bullet)
		bullet.fire(direction)


	if is_on_floor():
		if velocity.x != 0:
			sprite.play("run")
		elif just_fired:
			sprite.play("fire")
		else:
			sprite.play("idle")
	else:
		sprite.play("jump")

	move_and_slide()
