extends State

@export var player_body: PlayerBody
@export var player_actor: PlayerActor3D

func enter() -> void:
	ApplicationManager.system_log("Entering Move/Sprint State")
	player_actor.set_state("sprint")

func update(_delta: float) -> void:
	if player_body.velocity.length() <= 0:
		# Transition using the state's ID or ID path if nested
		transition("Idle")
		return
	if !player_body.is_on_floor():
		transition("InAir")
		return
	
