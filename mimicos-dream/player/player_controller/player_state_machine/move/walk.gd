extends State

@export var player_controller: PlayerController
@export var player_body: PlayerBody
@export var player_actor: PlayerActor3D

var is_fading: bool = false
var is_state_active: bool = false

func enter() -> void:
	player_controller.blackboard.pre_state = player_controller.blackboard.state
	player_controller.blackboard.state = "walk"
	
func exit() -> void:
	is_state_active = false

func update(_delta: float) -> void:
	if player_body.velocity.length() <= 0:
		transition("Idle")
		return
	if !player_body.is_on_floor():
		transition("InAir")
		return
	if player_controller.blackboard.is_dashing:
		transition("Move/Run")
