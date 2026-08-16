class_name PlayerController extends Node3D

var TEAM_COLORS: Array[Color] = [
	Color.from_string("#eae64f", Color.YELLOW), # alternative #c9c02f
	Color.from_string("#4fadc2", Color.NAVY_BLUE), #alternative #1d5be9
	Color.from_string("#c80e4c", Color.DARK_RED),
	Color.from_string("#78bf69", Color.LIME_GREEN) 
]

@export var player_body: PlayerBody
@export var player_actor: PlayerActor3D
@export var player_state_machine: FiniteStateMachine
@export var player_properties: PlayerProperties
@export var animation_player: AnimationPlayer

@export var player_interactable: PlayerInteractable

@export var head: Marker3D
@export var pin_join: Generic6DOFJoint3D

@export var id: int = 1

@export_enum('idle', 'walk', 'punching', 'stunned', 'taunt', 'hide', 'flying') var state: String = 'idle':
	set(value):
		if state == value:
			return
		pre_state = state
		state = value
		state_changed.emit(state)

@export var team: int = 1:
	set(value):
		if team == value:
			return
		team = value
		team_changed.emit(team)
		
@export var is_spectator: bool = false

@export var input_manager: InputManager
@export var player_actor_mover: PlayerActorMover

var pre_state: String = 'idle'
var controller_input: ControllerInput = ControllerInput.new()

var pluged_input_manager: Dictionary[int, InputManager] = {}


signal controller_input_changed(controller_input: ControllerInput)
signal command_bus(command: PlayerControllerCommand)

signal team_changed(team: int)
signal state_changed(state: String)

func _ready() -> void:
	change_team(team)
	team_changed.connect(self.change_team)
	player_actor.set_outline(false)
	player_actor_mover.activated()
	#player_properties = player_properties.duplicate()
	state_changed.connect(self._on_state_changed)
	if input_manager:
		plug_in_input_manager(input_manager)
	
		
func change_team(_team: int):
	if !player_actor:
		return
	var color = get_player_color(_team)
	player_actor.set_color(color)
	
func update_controller_input(_controller_input: ControllerInput) -> void:
	controller_input = _controller_input
	controller_input_changed.emit(controller_input)

func send_command(command: PlayerControllerCommand) -> void:
	_command_filter(command)
	
func _command_filter(command: PlayerControllerCommand) -> void:
	if command.player_id != id:
		return
	command_bus.emit(command)

func input_active_state_machine() -> void:
	self.player_state_machine.transition("PlayerInputActiveControlled")

func idle_state_machine() -> void:
	self.player_state_machine.transition("PlayerIdleControlled")
	
func plug_in_input_manager(_input_manager: InputManager) -> void:
	if !_input_manager:
		ApplicationManager.warn("missing input_manager", _input_manager)
		return
	var player_id = _input_manager.player_id
	if !player_id:
		ApplicationManager.warn("missing input_manager player_id", _input_manager)
		return
	if pluged_input_manager.get(player_id, null) != null:
		return
	pluged_input_manager.set(player_id, _input_manager)
	update_controller_input(_input_manager.controller_input)

func unplug_input_manager(_input_manager: InputManager) -> void:
	if !_input_manager:
		ApplicationManager.warn("missing input_manager", _input_manager)
		return
	var player_id = _input_manager.player_id
	if !player_id:
		ApplicationManager.warn("missing input_manager player_id", _input_manager)
		return
	if pluged_input_manager.get(player_id, null) == null:
		return
	pluged_input_manager.erase(player_id)
	update_controller_input(ControllerInput.new())
		

func get_player_color(_team: int) -> Color:
	if _team > TEAM_COLORS.size():
		return Color.TRANSPARENT
	return TEAM_COLORS.get(_team - 1)


func _on_state_changed(_state: String) -> void:
	match(_state):
			'idle':
				player_actor.set_animation("idle")
			'walk':
				player_actor.set_animation("walk")
