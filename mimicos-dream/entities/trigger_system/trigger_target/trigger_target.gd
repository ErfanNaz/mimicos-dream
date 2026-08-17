class_name TriggerTarget extends Node3D

@export var on_animation: String = "on"
@export var off_animation: String = "off"
@export var animation_player: AnimationPlayer
@export var is_on: bool = false:
	set(value):
		if value == is_on:
			return
		is_on = value
		if is_on:
			animation_player.play(on_animation)
			return
		if off_animation != "":
			animation_player.play(off_animation)
			return
		animation_player.pause()
		
