extends CharacterBody2D

const MAX_SPEED_HORIZ = 500.0
const MAX_SPEED_VERT = 500.0
const DECEL = 2600.0
const ACCEL = 4200.0
const ACCEL_VERT = 4200.0
const ACCEL_HORIZ = 6400.0
@export var field:ColorRect
@export var weapon:PackedScene
@export var max_health = 6
@onready var health = max_health
@onready var weapon_sfx := $BlastSfx
@onready var health_bar := $HealthBar
var invincible := false
signal damaged(new_health:int)
signal died

## damage done to objects the player collides with
var strength = 5

## delay in seconds between shots
var rate_of_fire := 0.3
var fire_delay_counter := 0.0

func _ready() -> void:
	health_bar.max_value = max_health
	health_bar.value = health

func _physics_process(delta: float) -> void:
	var direction := Vector2.ZERO
	direction.x = Input.get_axis("ui_left", "ui_right")
	direction.y = Input.get_axis("ui_up", "ui_down")
	direction = direction.normalized()

	if direction.x > 0:
		velocity.x = move_toward(velocity.x, MAX_SPEED_HORIZ, delta * ACCEL_HORIZ)
	elif direction.x < 0:
		velocity.x = move_toward(velocity.x, -MAX_SPEED_HORIZ, delta * ACCEL_HORIZ)
	else:
		velocity.x = move_toward(velocity.x, 0, delta * DECEL)

	if direction.y > 0:
		velocity.y = move_toward(velocity.y, MAX_SPEED_VERT, delta * ACCEL_VERT)
	elif direction.y < 0:
		velocity.y = move_toward(velocity.y, -MAX_SPEED_VERT, delta * ACCEL_VERT)
	else:
		velocity.y = move_toward(velocity.y, 0, delta * DECEL)

	move_and_slide()

	if field != null:
		position = position.clamp(field.position, field.position + field.size)
		
		
#	_handle_collisions()
#
#func _handle_collisions() -> void:
#	for i in get_slide_collision_count():
#		var collision := get_slide_collision(i)
#		var collider := collision.get_collider()
#
#		if collider.has_method("")
#		print("Collided with: ", collider.name)
#		collider.queue_free()

func damage(amount):
	if invincible:
		return

	health -= amount
	health_bar.value = health
	damaged.emit(health)

	if health == 1:
		modulate = Color(0.7, 0.5, 0.5, 1)

	if health <= 0:
		died.emit()
		queue_free()

func _process(delta: float) -> void:
	fire_delay_counter -= delta
	
	if fire_delay_counter <= 0 and Input.is_action_pressed("ui_accept"):
		fire_delay_counter = rate_of_fire
		var bullet = weapon.instantiate()
		bullet.global_position = global_position
		Sound.play_sfx(weapon_sfx)
		get_tree().get_root().add_child(bullet)
		bullet.fire(0)
		
	if Input.is_action_just_released("ui_accept"):
		fire_delay_counter = 0.0

func _input(event: InputEvent) -> void:
	if OS.is_debug_build() and event.is_action_pressed("bullet_heck_debug_invincible_toggle"):
		toggle_invincibility()
func toggle_invincibility():
	invincible = !invincible
	if invincible:
		modulate.b = 0.6
		modulate.r = 0.6
		modulate.g = 0.8
	else:
		modulate.b = 1.0
		modulate.r = 1.0
		modulate.g = 1.0
