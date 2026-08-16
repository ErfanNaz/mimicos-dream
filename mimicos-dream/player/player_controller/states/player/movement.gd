extends State

func enter() -> void:
	ApplicationManager.system_log("PlayerState Movement")

func physics_update(delta: float):
	transition("Movement/walk")
