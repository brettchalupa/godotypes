class_name Enemy extends RigidBody2D

enum FirePattern {
	SINGLE,
	DOUBLE,
	SPREAD,
	CIRCLE,
}

@export var fire_pattern:FirePattern = FirePattern.SINGLE
@export var bullet_movement:Bullet.BulletMovement = Bullet.BulletMovement.STRAIGHT
@export var fire_delay:float = 1.5
@export var bullet_lifetime:float = 3
@export var bullet_scene:PackedScene
@onready var weapon_sfx := $WeaponSfx
@onready var timer := $FireTimer
@export var health := 5
var target_pos = null
var reached_target_pos := false

var speed = 300.0

signal died

func _ready() -> void:
	timer.wait_time = fire_delay
	if target_pos == null:
		_reached_pos()

func _physics_process(delta: float) -> void:
	if target_pos != null and !reached_target_pos:
		position = position.move_toward(target_pos, delta * speed)
		if position.distance_to(target_pos) == 0:
			_reached_pos()

	move_and_collide(linear_velocity)

func _reached_pos():
		reached_target_pos = true
		_on_fire_timer_timeout()
		timer.start()
func _on_fire_timer_timeout() -> void:
	match fire_pattern:
		FirePattern.SINGLE:
			fire_bullet(global_position, rotation_degrees)
			Sound.play_sfx(weapon_sfx)
		FirePattern.DOUBLE:
			var spacer = Vector2(18, 0)
			fire_bullet(global_position + spacer, rotation_degrees)
			fire_bullet(global_position - spacer, rotation_degrees)
			Sound.play_sfx(weapon_sfx)
		FirePattern.SPREAD:
			fire_bullet(global_position, rotation_degrees)
			fire_bullet(global_position, rotation_degrees - 20)
			fire_bullet(global_position, rotation_degrees + 20)
			Sound.play_sfx(weapon_sfx)
		FirePattern.CIRCLE:
			var shots = 16
			for n in shots:
				fire_bullet(global_position, 360.0 / shots * n)
			Sound.play_sfx(weapon_sfx)

func fire_bullet(pos: Vector2, angle_deg: float):
	var bullet = bullet_scene.instantiate()
	bullet.global_position = pos
	get_tree().get_root().add_child(bullet)
	bullet.fire(deg_to_rad(angle_deg), bullet_lifetime, bullet_movement)
	return bullet

func stop_firing():
	timer.paused = true

func resume_firing():
	timer.paused = false

func damage(amount):
	health -= amount
	if health == 1:
		modulate = Color(0.7, 0.5, 0.5, 1)
	if health <= 0:
		# TODO: explode
		# TODO: sfx
		died.emit()
		queue_free()
