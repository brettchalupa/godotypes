extends RigidBody2D

enum FirePattern {
	SINGLE,
	DOUBLE,
	SPREAD,
	CIRCLE,
}

@export var fire_pattern:FirePattern = FirePattern.SINGLE
@export var bullet_movement:Bullet.BulletMovement = Bullet.BulletMovement.STRAIGHT
@export var fire_delay:float = 1
@export var bullet_lifetime:float = 1
@export var bullet_scene:PackedScene
@onready var weapon_sfx := $WeaponSfx
@onready var timer := $FireTimer

func _ready() -> void:
	timer.wait_time = fire_delay
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
				fire_bullet(global_position, (360 / shots) * n)
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
