extends CharacterBody3D


const xy_accel = 400.0
const ryp_accel = 100.0 # roll yaw pitch
const xy_speed = 20.0
const ryp_deg = 30.0
var forward_speed = 20.0
var forward_paused = false

func _physics_process(delta: float) -> void:
	var input_dir := Input.get_vector("ui_right", "ui_left", "ui_down", "ui_up")
	var direction := (transform.basis * Vector3(input_dir.x, input_dir.y, 0)).normalized()
	if direction:
		velocity.x = move_toward(velocity.x, direction.x * xy_speed, xy_accel * delta)
		velocity.y = move_toward(velocity.y, direction.y * xy_speed, xy_accel * delta)
		rotation_degrees = rotation_degrees.move_toward(Vector3(direction.y, 0, direction.x) * -ryp_deg, ryp_accel * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, xy_speed * delta * 2)
		velocity.y = move_toward(velocity.y, 0, xy_speed * delta * 2)
		rotation_degrees = rotation_degrees.move_toward(Vector3(0, 0, 0), ryp_accel * delta)
	
	if !forward_paused:
		velocity.z = forward_speed
	else:
		velocity.z = 0.0

	move_and_slide()

func _input(event: InputEvent) -> void:
	if OS.is_debug_build() && event.is_action_pressed("stardog_debug_toggle_player_z"):
		forward_paused = !forward_paused
