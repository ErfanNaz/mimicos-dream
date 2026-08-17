extends State

@export var player_controller: PlayerController
@export var player_body: PlayerBody
@export var player_actor: PlayerActor

func enter() -> void:
	player_controller.blackboard.pre_state = player_controller.blackboard.state
	player_controller.blackboard.state = "jump"
	
func update(_delta: float) -> void:
	if player_body.velocity.length() == 0:
		transition("Idle")
		return
	if player_body.velocity.y < 0:
		transition("InAir/Fall")
		return
