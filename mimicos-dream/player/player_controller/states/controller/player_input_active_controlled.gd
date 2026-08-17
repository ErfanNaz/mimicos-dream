class_name PlayerInputActiveControlled extends State

@export var player_controller: PlayerController
@export var player_body: PlayerBody

@export var mouse_sensitivity: float = 0.1
@export var controller_sensitivity: float = 90.0
@export var min_pitch: float = -40.0
@export var max_pitch: float = 20.0
@export var target_anchor_node_3d: Node3D


@export_category("Internal")
@export var dash_timer: Timer


var accumulator: float = 0

var direction: Vector2 = Vector2.ZERO
var controller_input: ControllerInput
var input_manager: InputManager
var camera_system: CameraSystem

var is_conntected: bool = false
var is_dashing: bool = false
var is_stunned: bool = false

func _ready() -> void:
	set_process_input(false)

func enter() -> void:
	controller_input = player_controller.controller_input
	input_manager = player_controller.input_manager
	camera_system = GameManager.camera_system
	set_process_input(true)
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	dash_timer.timeout.connect(self._on_dash_finished)
	
func exit() -> void:
	set_process_input(false)
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	dash_timer.timeout.disconnect(self._on_dash_finished)

func physics_update(delta: float) -> void:
	process_tick(delta, controller_input)

func process_tick(delta: float, _controller_input: ControllerInput) -> void:
	var velocity: Vector3 = player_body.velocity
	var player_properties: PlayerProperties = player_controller.player_properties
	if !player_body.is_on_floor():
		velocity += player_body.get_gravity() * delta
			
	var running: float = 1
	
	if !is_stunned:
		if _controller_input.in_menu:
			return
	
	if controller_input.lookup_direction.length() != 0:
		update_lookpu_direction(delta)
	
	if player_body.is_on_floor() and input_manager.is_action_pressed(0):
		velocity.y += player_properties.jump
	
	var move_direction: Vector3 = get_move_direction(_controller_input.direction)
	direction = Vector2(move_direction.x, move_direction.z).normalized()
	
	if input_manager.is_action_pressed(1):
		start_dash()
	
	if is_dashing:
		running = player_properties.dash_speed
	
	if direction.length() > 0:
		var target_y_rotation = atan2(direction.x, direction.y)
		player_body.rotation.y = target_y_rotation

	var _velocity: Vector2 = direction * player_properties.speed * running
		
	player_body.velocity = Vector3(_velocity.x, velocity.y, _velocity.y)
	player_body.move_and_slide()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_camera_mouse(event.relative)


func start_dash() -> void:
	if is_dashing:
		return
	is_dashing = true
	dash_timer.start()

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


func update_lookpu_direction(delta: float) -> void:
	var look_input := controller_input.lookup_direction

	# Horizontal
	if look_input.x != 0.0:
		target_anchor_node_3d.rotate_y(
			look_input.x * deg_to_rad(controller_sensitivity) * delta
		)

	# Vertikal
	if look_input.y != 0.0:
		var spring_arm := target_anchor_node_3d

		spring_arm.rotation_degrees.x -= (
			look_input.y * controller_sensitivity * delta
		)

		spring_arm.rotation_degrees.x = clamp(
			spring_arm.rotation_degrees.x,
			min_pitch,
			max_pitch
		)

func _on_dash_finished() -> void:
	if !is_dashing:
		return
	is_dashing = false
