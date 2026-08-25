class_name StagedAnimationController extends Node

@export var animations: Array[String] = []
@export var blend_time: float = 0.2

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var animation_tree: AnimationTree
var blend_tree: AnimationNodeBlendTree

var current_stage := 0
var tween: Tween


func _ready() -> void:
	_build_tree()


func _build_tree() -> void:
	if animations.is_empty():
		return

	animation_tree = AnimationTree.new()
	animation_tree.name = "AnimationTree"
	animation_tree.anim_player = animation_player.get_path()

	add_child(animation_tree)

	blend_tree = AnimationNodeBlendTree.new()
	animation_tree.tree_root = blend_tree

	# Erste Animation
	var previous := AnimationNodeAnimation.new()
	previous.animation = animations[0]

	blend_tree.add_node(
		"Animation_0",
		previous,
		Vector2(0, 0)
	)

	var previous_name := "Animation_0"

	# Restliche Animationen
	for i in range(1, animations.size()):
		var animation_node := AnimationNodeAnimation.new()
		animation_node.animation = animations[i]

		var animation_name := "Animation_%d" % i
		var blend_name := "Blend_%d" % i

		blend_tree.add_node(
			animation_name,
			animation_node,
			Vector2(0, i * 150)
		)

		var blend := AnimationNodeBlend2.new()

		blend_tree.add_node(
			blend_name,
			blend,
			Vector2(300, i * 150)
		)

		blend_tree.connect_node(blend_name, 0, previous_name)
		blend_tree.connect_node(blend_name, 1, animation_name)

		previous_name = blend_name

	blend_tree.connect_node("output", 0, previous_name)

	animation_tree.active = true

	# Initialer Zustand
	_set_stage_immediately(0)


func _set_stage_immediately(stage: int) -> void:
	for i in range(1, animations.size()):
		var value := 1.0 if i <= stage else 0.0
		_set_blend(i, value)


func _set_blend(index: int, value: float) -> void:
	var parameter := "parameters/Blend_%d/blend_amount" % index
	animation_tree.set(parameter, value)


func set_stage(stage: int) -> void:
	stage = clampi(stage, 0, animations.size() - 1)

	if stage == current_stage:
		return

	if tween:
		tween.kill()

	var previous_stage := current_stage
	current_stage = stage

	tween = create_tween()

	if stage > previous_stage:
		# Beispiel:
		# 0 -> 1
		# Blend_1: 0 -> 1
		#
		# 1 -> 2
		# Blend_2: 0 -> 1
		for i in range(previous_stage + 1, stage + 1):
			_tween_blend(i, 1.0)

	else:
		# Beispiel:
		# 2 -> 1
		# Blend_2: 1 -> 0
		#
		# 1 -> 0
		# Blend_1: 1 -> 0
		for i in range(previous_stage, stage, -1):
			_tween_blend(i, 0.0)


func _tween_blend(index: int, target: float) -> void:
	var parameter := "parameters/Blend_%d/blend_amount" % index

	tween.tween_method(
		func(value: float) -> void:
			animation_tree.set(parameter, value),
		animation_tree.get(parameter),
		target,
		blend_time
	)
