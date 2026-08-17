class_name DoorSystem extends Node3D

@export var open_animation: String = "open"
@export var close_animation: String = "close"
@export var animation_player: AnimationPlayer

@export_category("trigger settings")
@export_range(0, 10, 1, "prefer_slider") var toggle_back_timer: int = 0

@export_category("Internal")
@export var door: Door
@export var door_trigger: DoorTrigger

func _ready() -> void:
	door.open_animation = open_animation
	door.close_animation = close_animation
	door.animation_player = animation_player
	door_trigger.toggle_back_timer = toggle_back_timer
