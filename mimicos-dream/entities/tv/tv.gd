extends Node3D

@export_category("Internal")
@export var video_stream_player: VideoStreamPlayer
@export var trigger_switch: TriggerSwitch

var turned_on: bool = false

func _ready() -> void:
	trigger_switch.on_switch.connect(self._on_switch_toggle)
	
func _on_switch_toggle(player_controller: PlayerController, on: bool) -> void:
	if on:
		if !turned_on:
			video_stream_player.play()
			turned_on = true
		else:
			video_stream_player.paused = false
	else:
		video_stream_player.paused = true
