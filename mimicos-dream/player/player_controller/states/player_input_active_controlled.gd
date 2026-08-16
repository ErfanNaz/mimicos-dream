class_name PlayerInputActiveControlled extends State

@export var player_controller: PlayerController
@export var player_body: PlayerBody

var accumulator: float = 0

var direction: Vector2 = Vector2.ZERO
var controller_input: ControllerInput

var is_conntected: bool = false
var is_dashing: bool = false

var last_input_version: int = 0

const MIN_PLAYER_Y_POSITION = -100

var is_stunned: bool = false

var TICK_RATE = 20
var TICK_DT = 1.0 / TICK_RATE

var state: String = 'idle'

const MAX_STEPS: int = 5


func _ready() -> void:
	controller_input = player_controller.controller_input
	set_physics_process(false)
	

func enter() -> void:
	self.set_physics_process(true)
	if is_conntected:
		return
	is_conntected = true
	last_input_version = 0
	controller_input = player_controller.controller_input
	player_controller.controller_input_changed.connect(self._input_changed)
	#player_controller.player_interactable.on_player_hunted.connect(self.on_player_hunted)
	
func exit() -> void:
	if !is_conntected:
		return
	player_controller.controller_input_changed.disconnect(self._input_changed)
	#player_controller.player_interactable.on_player_hunted.disconnect(self.on_player_hunted)
	is_conntected = false
	last_input_version = 0
	self.set_physics_process(false)

func _input_changed(new_controller_input: ControllerInput) -> void:
	controller_input = new_controller_input

func _physics_process(delta: float):
	if !ServerClientApi.is_server():
		ApplicationManager.warn("Running server process local")
		self.set_physics_process(false)
		return
	process_tick(delta, controller_input)
	player_controller.state = state

func process_tick(delta: float, _controller_input: ControllerInput) -> void:
	var velocity: Vector3 = player_body.velocity
	var player_properties: PlayerProperties = player_controller.player_properties
	if !player_body.is_on_floor():
		velocity += player_body.get_gravity() * 2 * delta
	state = 'idle'
	
	
	var running: float = 1
	
	if !is_stunned:
		if _controller_input.in_menu:
			return
	
	direction = _controller_input.direction.normalized()
	
	if is_dashing:
		running = player_properties.dash_speed
	
	if direction.length() > 0:
		var target_y_rotation = atan2(direction.x, direction.y)
		player_body.rotation.y = target_y_rotation

	var _velocity: Vector2 = direction * player_properties.speed * running
	
	if velocity.length() > 0.1:
		state = 'walking'
	
	player_body.velocity = Vector3(_velocity.x, velocity.y, _velocity.y)
	player_body.move_and_slide()
