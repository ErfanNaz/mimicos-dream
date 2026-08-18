class_name PlayerActorWalk extends State

@export var player_actor: PlayerActor3D
@export var animation_tree: AnimationTree

func enter() -> void:
	animation_tree.set("parameters/walk/blend_amount", 1)
	player_actor.set_face(3)

func exit() -> void:
	animation_tree.set("parameters/walk/blend_amount", 0)
