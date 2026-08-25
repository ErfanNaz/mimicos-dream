class_name BlendTreeSystem extends Node3D

@export var animations: Array[String] = []

@export_category("Internal")
@export var staged_animation_controller: StagedAnimationController

func _ready() -> void:
	staged_animation_controller.animations = animations
	staged_animation_controller._build_tree()
