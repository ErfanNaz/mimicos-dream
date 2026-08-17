extends State

@export var player_actor: PlayerActor3D
@export var animation_player: AnimationPlayer

func enter() -> void:
	animation_player.play("jump")
	#player_actor.set_face(3)
