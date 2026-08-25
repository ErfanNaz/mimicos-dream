class_name IdleControlled extends State

@export var player_controller: PlayerController

var player_body: PlayerBody

func enter() -> void:
	player_controller.blackboard.controller_state = StateBlackboard.PlayerControllerState.idle
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	player_body = player_controller.player_body

func physics_update(delta: float) -> void:
	if player_body.is_on_floor():
		return
	player_body.velocity += player_body.get_gravity() * delta
	player_body.move_and_slide()
