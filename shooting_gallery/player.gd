extends CharacterBody3D


const SPEED = 8.0
const JUMP_VELOCITY = 6.0
const LOOK_SENSITIVITY = 0.02

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

@export var bullet_scene:PackedScene
@onready var camera:Camera3D = $Camera3D
@onready var blaster:Node3D = $blasterD

func _physics_process(delta: float) -> void:
	var joypad_camera_vec = Input.get_vector("shooting_gallery_look_down", "shooting_gallery_look_up", "shooting_gallery_look_right", "shooting_gallery_look_left")

	if joypad_camera_vec.x != 0.0:
		camera.rotate_x(joypad_camera_vec.x * LOOK_SENSITIVITY)
		clamp_camera_rot()
	if joypad_camera_vec.y != 0.0:
		rotate_y(joypad_camera_vec.y * LOOK_SENSITIVITY)

	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
	
	if Input.is_action_just_pressed("shooting_gallery_fire"):
		$FireSfx.play()
		var bullet = bullet_scene.instantiate()
		get_tree().get_root().add_child(bullet)
		bullet.global_position = $Camera3D/FirePoint.global_position
		bullet.look_at($Camera3D/RayCast3D.get_collision_point(), Vector3.UP)
		bullet.apply_impulse(-bullet.transform.basis.z * BULLET_FORCE, bullet.transform.basis.z)

const BULLET_FORCE = 80
func _input(event):
	if event.is_action_pressed("shooting_gallery_toggle_mouse_mode"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE else Input.MOUSE_MODE_VISIBLE

	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * LOOK_SENSITIVITY)
		camera.rotate_x(-event.relative.y * LOOK_SENSITIVITY)
		clamp_camera_rot()

func clamp_camera_rot():
	camera.rotation.x = clamp(camera.rotation.x, -PI/2, PI/2)
