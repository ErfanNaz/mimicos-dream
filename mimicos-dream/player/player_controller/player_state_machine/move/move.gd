extends State

@export var player_controller: PlayerController
@export var player_body: PlayerBody

func enter() -> void:
	player_controller.blackboard.selector = "move"
	
func update(_delta: float) -> void:
	if player_body.velocity.length() > 0:
		transition("Move/Run")
		return
	if !player_body.is_on_floor():
		transition("InAir")
		return
	transition("Idle")
