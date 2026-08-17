extends State

@export var player_controller: PlayerController
@export var player_body: PlayerBody
@export var player_actor: PlayerActor3D

func enter() -> void:
	ApplicationManager.system_log("PlayerState InAir/fall")
	player_actor.set_animation("fall")
	player_controller.state = "fall"
	
func physics_update(delta: float) -> void:
	if player_body.is_on_floor():
		if player_controller.controller_input.direction.length() == 0:
			transition("idle")
			return
		else:
			transition("Movement")
			return
	if player_body.velocity.y > 0:
		transition("InAir/jump")
		return
