extends Node3D

@export var audio_stream_player_3d: AudioStreamPlayer3D

var pause_position := 0.0

var is_on: bool = false
var can_switch: bool = true

func _on_interaction_on_interact(player_controller: PlayerController) -> void:
	if !can_switch:
		return
	can_switch = false
	is_on = !is_on
	if is_on:
		audio_stream_player_3d.play(pause_position)
	else:
		pause_position = audio_stream_player_3d.get_playback_position()
		audio_stream_player_3d.stop()
	await get_tree().create_timer(1).timeout
	can_switch = true
