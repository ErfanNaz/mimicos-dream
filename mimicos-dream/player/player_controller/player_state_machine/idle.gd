extends State

@export var player_controller: PlayerController
@export var player_body: PlayerBody
@export var player_actor: PlayerActor3D

func enter() -> void:
	player_controller.blackboard.pre_state = player_controller.blackboard.state
	player_controller.blackboard.state = "idle"
	player_controller.footstap_audio_stream_player.stop()

func update(delta: float) -> void:
	if player_body.velocity.length() > 0:
		transition("Move")
