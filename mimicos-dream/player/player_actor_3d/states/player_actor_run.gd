extends State

@export var player_actor: PlayerActor3D
@export var animation_tree: AnimationTree

func enter() -> void:
	animation_tree.set("parameters/run/blend_amount", 1)

func exit() -> void:
	animation_tree.set("parameters/run/blend_amount", 0)
