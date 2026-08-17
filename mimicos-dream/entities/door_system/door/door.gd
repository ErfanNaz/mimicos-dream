class_name Door extends Node3D

@export var open_animation: String = "open"
@export var close_animation: String = "close"
@export var animation_player: AnimationPlayer
@export var is_open: bool = false:
	set(value):
		if value == is_open:
			return
		is_open = value
		if is_open:
			animation_player.play(open_animation)
		else:
			animation_player.play(close_animation)
		
