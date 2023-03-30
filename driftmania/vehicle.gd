extends VehicleBody3D

@export var max_rpm := 800.0
@export var max_torque := 200.0
@export var break_force := 200.0
@export var drift_force := 20.0
@export var steer_force := 0.4

@onready var wheel_rear_left = $"Wheel-RearLeft"
@onready var wheel_rear_right = $"Wheel-RearRight"

func _physics_process(delta: float) -> void:
	steering = lerp(steering, Input.get_axis("ui_right", "ui_left")  * steer_force, 5 * delta)
	var accel = Input.get_axis("ui_up", "ui_down")
	var rpm = abs(wheel_rear_left.get_rpm())
	wheel_rear_left.engine_force = accel * max_torque * (1 - rpm / max_rpm)
	rpm = abs(wheel_rear_right.get_rpm())
	wheel_rear_right.engine_force = accel * max_torque * (1 - rpm / max_rpm)

	if Input.is_action_pressed("ui_accept"):
		brake = break_force
	elif Input.is_action_pressed("ui_cancel"):
		brake = drift_force
	else:
		brake = 0
