class_name PlayerInputActiveControlled extends State

@export var player_controller: PlayerController
@export var player_body: PlayerBody

var accumulator: float = 0

var direction: Vector2 = Vector2.ZERO
var controller_input: ControllerInput
var input_manager: InputManager

var is_conntected: bool = false
var is_dashing: bool = false

var last_input_version: int = 0

const MIN_PLAYER_Y_POSITION = -100

var is_stunned: bool = false

var TICK_RATE = 20
var TICK_DT = 1.0 / TICK_RATE

const MAX_STEPS: int = 5

func enter() -> void:
	last_input_version = 0
	controller_input = player_controller.controller_input
	input_manager = player_controller.input_manager
	
func exit() -> void:
	last_input_version = 0

func physics_update(delta: float) -> void:
	process_tick(delta, controller_input)

func process_tick(delta: float, _controller_input: ControllerInput) -> void:
	var velocity: Vector3 = player_body.velocity
	var player_properties: PlayerProperties = player_controller.player_properties
	if !player_body.is_on_floor():
		velocity += player_body.get_gravity() * 2 * delta
			
	var running: float = 1
	
	if !is_stunned:
		if _controller_input.in_menu:
			return
	
	if player_body.is_on_floor() and input_manager.is_action_pressed(0):
		velocity.y += player_properties.jump
	
	direction = _controller_input.direction.normalized()
	
	if is_dashing:
		running = player_properties.dash_speed
	
	if direction.length() > 0:
		var target_y_rotation = atan2(direction.x, direction.y)
		player_body.rotation.y = target_y_rotation

	var _velocity: Vector2 = direction * player_properties.speed * running
		
	player_body.velocity = Vector3(_velocity.x, velocity.y, _velocity.y)
	player_body.move_and_slide()
