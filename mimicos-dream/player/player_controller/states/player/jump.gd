extends State

@export var player_body: PlayerBody
@export var player_actor: PlayerActor3D

func enter() -> void:
	ApplicationManager.system_log("PlayerState InAir/jump")
	player_actor.set_animation("jump")
	
func physics_update(delta: float) -> void:
	if player_body.is_on_floor():
		transition("idle")
		return
	if player_body.velocity.y < 0:
		transition("InAir/fall")
		return
