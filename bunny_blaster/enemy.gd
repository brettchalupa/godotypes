extends CharacterBody2D


const SPEED = 20.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
@export var max_health = 3
@onready var health = max_health
@onready var sprite = $AnimatedSprite2D
@onready var flash_timer = $FlashTimer
@onready var turn_timer = $TurnTimer
@onready var ledge_cast = $LedgeCast
var direction = Vector2.RIGHT

func _ready() -> void:
	sprite.play("walk")

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta

	if is_on_wall() or !ledge_cast.is_colliding():
		turn_timer.start()
		direction *= -1

	velocity.x = direction.x * SPEED

	sprite.flip_h = direction.x < 1
	move_and_slide()

func damage(amount):
	health -= amount
	
	if health <= 0:
		queue_free()
	else:
		modulate = Color(0.8, 0.4, 0.4)
		flash_timer.start()

func _on_flash_timer_timeout() -> void:
	modulate = Color(1.0, 1.0, 1.0)

func _on_turn_timer_timeout() -> void:
	direction.x *= -1
