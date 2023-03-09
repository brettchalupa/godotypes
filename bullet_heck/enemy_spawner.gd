extends Node

var waves := {
	1: [
		{
			"fire_pattern": Enemy.FirePattern.SINGLE,
			"bullet_movement": Bullet.BulletMovement.STRAIGHT,
			"anchor": Anchor.Middle,
		}
	],
	2: [
		{
			"fire_pattern": Enemy.FirePattern.SINGLE,
			"bullet_movement": Bullet.BulletMovement.STRAIGHT,
			"anchor": Anchor.Left,
		},
		{
			"fire_pattern": Enemy.FirePattern.SINGLE,
			"bullet_movement": Bullet.BulletMovement.STRAIGHT,
			"anchor": Anchor.Right,
		}
	],
	3: [
		{
			"fire_pattern": Enemy.FirePattern.SINGLE,
			"bullet_movement": Bullet.BulletMovement.STRAIGHT,
			"anchor": Anchor.Left,
		},
		{
			"fire_pattern": Enemy.FirePattern.SINGLE,
			"bullet_movement": Bullet.BulletMovement.STRAIGHT,
			"anchor": Anchor.Right,
		},
		{
			"fire_pattern": Enemy.FirePattern.SINGLE,
			"bullet_movement": Bullet.BulletMovement.STRAIGHT,
			"anchor": Anchor.Middle,
		}
	],
	4: [
		{
			"fire_pattern": Enemy.FirePattern.SINGLE,
			"bullet_movement": Bullet.BulletMovement.STRAIGHT,
			"anchor": Anchor.Left,
		},
		{
			"fire_pattern": Enemy.FirePattern.SINGLE,
			"bullet_movement": Bullet.BulletMovement.STRAIGHT,
			"anchor": Anchor.Right,
		},
		{
			"fire_pattern": Enemy.FirePattern.DOUBLE,
			"bullet_movement": Bullet.BulletMovement.STRAIGHT,
			"anchor": Anchor.Middle,
		}
	],
	5: [
		{
			"fire_pattern": Enemy.FirePattern.SPREAD,
			"bullet_movement": Bullet.BulletMovement.STRAIGHT,
			"anchor": Anchor.Left,
		},
		{
			"fire_pattern": Enemy.FirePattern.SPREAD,
			"bullet_movement": Bullet.BulletMovement.STRAIGHT,
			"anchor": Anchor.Right,
		},
		{
			"fire_pattern": Enemy.FirePattern.DOUBLE,
			"bullet_movement": Bullet.BulletMovement.WIGGLY,
			"anchor": Anchor.Middle,
		}
	],
	6: [
		{
			"fire_pattern": Enemy.FirePattern.CIRCLE,
			"bullet_movement": Bullet.BulletMovement.STRAIGHT,
			"anchor": Anchor.Middle,
		}
	],
	7: [
		{
			"fire_pattern": Enemy.FirePattern.CIRCLE,
			"bullet_movement": Bullet.BulletMovement.STRAIGHT,
			"anchor": Anchor.Left,
		},
		{
			"fire_pattern": Enemy.FirePattern.CIRCLE,
			"bullet_movement": Bullet.BulletMovement.STRAIGHT,
			"anchor": Anchor.Right,
		}
	],
	8: [
		{
			"fire_pattern": Enemy.FirePattern.CIRCLE,
			"bullet_movement": Bullet.BulletMovement.ARC,
			"anchor": Anchor.Middle,
		}
	],
}

enum Anchor {
	Left,
	Right,
	Middle,
}

@export var enemy_scene:PackedScene
@export var current_wave = 1
var enemies_in_wave = []
signal wave_started(wave:int)
signal won

func start_wave():
	emit_signal("wave_started", current_wave)
	print_debug("starting wave: " + str(current_wave))
	
	if current_wave in waves:
		enemies_in_wave = []
		for enemy_attrs in waves[current_wave]:
			var enemy = enemy_scene.instantiate()
			enemy.fire_pattern = enemy_attrs.fire_pattern
			enemy.bullet_movement = enemy_attrs.bullet_movement
			enemy.rotation = deg_to_rad(180)
			enemy.target_pos = pos_for_anchor(enemy_attrs.anchor)
			enemy.global_position = enemy.target_pos - Vector2(0, 400)
			enemies_in_wave.push_back(enemy)
			enemy.connect("died", _enemy_died.bind(enemy))
			$Enemies.add_child(enemy)
	else:
		won.emit()
		

func start_next_wave():
	current_wave += 1
	$WaveDelay.start()

func _enemy_died(enemy):
	enemies_in_wave.erase(enemy)
	print_debug("enemies left in array: " + str(enemies_in_wave.size()))
	if enemies_in_wave.is_empty():
		start_next_wave()
	
func _on_wave_delay_timeout() -> void:
	start_wave()

func pos_for_anchor(anchor:Anchor):
	match anchor:
		Anchor.Left:
			return $EnemyAnchorLeft.global_position
		Anchor.Right:
			return $EnemyAnchorRight.global_position
		Anchor.Middle:
			return $EnemyAnchorMiddle.global_position
