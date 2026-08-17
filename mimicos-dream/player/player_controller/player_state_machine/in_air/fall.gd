extends State

@export var player_controller: PlayerController
@export var player_body: PlayerBody
@export var player_actor: PlayerActor3D

var is_in_landing: bool = false

func enter() -> void:
	player_controller.blackboard.pre_state = player_controller.blackboard.state
	player_controller.blackboard.state = "fall"
	
func update(_delta: float) -> void:
	if player_body.is_on_floor():
		transition("Idle")
		return

func _start_landing() -> void:
	if is_in_landing:
		return
	is_in_landing = true
	player_actor.set_state("land")
	await get_tree().create_timer(1).timeout
	is_in_landing = false
	transition("Idle")
