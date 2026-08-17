extends State

@export var player_controller: PlayerController
@export var player_body: PlayerBody

func enter() -> void:
	player_controller.blackboard.selector = "in_air"
	
func update(_delta: float) -> void:
	if player_body.velocity.length() == 0:
		transition("Idle")
		return 
	
	if player_body.is_on_floor():
		transition("Move")
		return
	
	if player_body.velocity.y > 0:
		transition("InAir/Jump")
		return
	else:
		transition("InAir/Fall")
