extends State

@export var player_body: PlayerBody
@export var player_actor: PlayerActor3D

func enter() -> void:
	ApplicationManager.system_log("PlayerState Movement/walk")
	player_actor.set_animation("walk")
	
func physics_update(delta: float) -> void:
	if player_body.velocity.length() <= 0:
		transition("idle")
		return
	if !player_body.is_on_floor():
		transition("InAir")
		return
