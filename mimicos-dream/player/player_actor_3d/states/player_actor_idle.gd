class_name PlayerActorIdle extends State

@export var player_actor: PlayerActor3D
@export var animation_tree: AnimationTree

func enter() -> void:
	animation_tree.set("parameters/run/blend_amount", 0)
	player_actor.set_face(2)
