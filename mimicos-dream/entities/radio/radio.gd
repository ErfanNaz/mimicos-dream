extends Node3D

@export var audio_stream_player_3d: AudioStreamPlayer3D

var pause_position := 0.0


func _on_trigger_switch_on_switch(player_controller: PlayerController, on: bool) -> void:
	if on:
		audio_stream_player_3d.play(pause_position)
	else:
		pause_position = audio_stream_player_3d.get_playback_position()
		audio_stream_player_3d.stop()
