class_name Bullet extends RigidBody2D

const SPEED := 600.0
@onready var timer := $Timer
var strength = 1
var hit_effect = preload("res://bullet_heck/hit_effect.tscn")

enum BulletMovement {
	STRAIGHT,
	WIGGLY,
	ARC,
}

var movement:BulletMovement = BulletMovement.STRAIGHT

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node):
	if body.has_method("damage"):
		body.damage(strength)
	var animation = hit_effect.instantiate()
	animation.global_position = body.global_position
	get_tree().get_root().add_child(animation)
	animation.play("default")
	queue_free()

func _process(_delta):
	if timer.time_left / timer.wait_time < 0.25:
		$Sprite2D.modulate.a = timer.time_left / timer.wait_time

func _physics_process(_delta: float) -> void:
	match movement:
		BulletMovement.STRAIGHT:
			# move as normal with linear velocity
			pass
		BulletMovement.WIGGLY:
			var mod = timer.time_left * 20
			position += Vector2(sin(mod), cos(mod)) * 10
		BulletMovement.ARC:
			var mod = timer.time_left * 3
			rotation += mod
			set_linear_velocity_from_rotation()

func _on_timer_timeout():
	queue_free()

## angle in rads to fire
## lifetime in secs to live
func fire(angle: float, lifetime:float=3.0, bmovement: BulletMovement=BulletMovement.STRAIGHT) -> void:
	movement = bmovement
	rotation = angle
	set_linear_velocity_from_rotation()
	timer.wait_time = lifetime
	timer.start()

func set_linear_velocity_from_rotation():
	linear_velocity = Vector2.UP.rotated(rotation) * SPEED
