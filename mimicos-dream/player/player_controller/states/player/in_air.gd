extends State

@export var player_body: PlayerBody

func enter() -> void:
	ApplicationManager.system_log("PlayerState InAir")
	if player_body.is_on_floor():
		transition("idle")
		return
	if player_body.velocity.y > 0:
		transition("InAir/jump")
	else:
		transition("InAir/fall")
