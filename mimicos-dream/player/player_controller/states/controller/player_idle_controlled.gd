class_name IdleControlled extends State

@export var mouse_sensitivity: float = 0.1
@export var controller_sensitivity: float = 90.0
@export var min_pitch: float = -40.0
@export var max_pitch: float = 20.0
@export var target_anchor_node_3d: Node3D

func _ready() -> void:
	set_process_input(false)

func enter() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	set_process_input(true)
	
func exit() -> void:
	set_process_input(false)
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_camera_mouse(event.relative)

func get_move_direction(input: Vector2) -> Vector3:
	var camera_forward := target_anchor_node_3d.global_transform.basis.z
	var camera_right := -target_anchor_node_3d.global_transform.basis.x

	camera_forward.y = 0.0
	camera_right.y = 0.0

	camera_forward = camera_forward.normalized()
	camera_right = camera_right.normalized()

	return (
		camera_right * input.x +
		camera_forward * -input.y
	).normalized()

func rotate_camera_mouse(mouse_delta: Vector2) -> void:
	var spring_arm := target_anchor_node_3d

	target_anchor_node_3d.rotate_y(
		deg_to_rad(-mouse_delta.x * mouse_sensitivity)
	)

	spring_arm.rotation_degrees.x += mouse_delta.y * mouse_sensitivity

	spring_arm.rotation_degrees.x = clamp(
		spring_arm.rotation_degrees.x,
		min_pitch,
		max_pitch
	)
