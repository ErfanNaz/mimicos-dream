extends State

@export var player_controller: PlayerController
@export var player_body: PlayerBody
@export var player_actor: PlayerActor3D

var is_fading: bool = false
var is_state_active: bool = false

func enter() -> void:
	player_controller.blackboard.pre_state = player_controller.blackboard.state
	player_controller.blackboard.state = "run"
	
func exit() -> void:
	is_state_active = false

func update(_delta: float) -> void:
	if player_body.velocity.length() <= 0:
		transition("Idle")
		return
	if !player_body.is_on_floor():
		transition("InAir")
		return
	if Input.is_action_just_pressed("RB"):
		crossfade_run_sprint()

func crossfade_run_sprint() -> void:
	if is_fading:
		return
	is_fading = true
	player_actor.set_animation("dash")
	await get_tree().create_timer(1).timeout
	is_fading = false
	if !is_state_active:
		return
	player_actor.set_animation("run")
