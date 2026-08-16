extends State

@export var player_controller: PlayerController
@export var player_body: PlayerBody
@export var player_actor: PlayerActor3D

func enter() -> void:
	ApplicationManager.system_log("PlayerState Idle")
	player_actor.set_animation("idle")
	player_controller.state = "idle"

func physics_update(delta: float) -> void:
	if !player_body.is_on_floor():
		transition("InAir")
		return
	if player_body.velocity.length() > 0:
		transition("Movement")
		return
