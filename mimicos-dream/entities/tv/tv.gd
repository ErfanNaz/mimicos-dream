extends Node3D

@export_category("Internal")
@export var video_stream_player: VideoStreamPlayer
@export var interaction: Interaction

var turned_on: bool = false

var is_on: bool = false
var can_switch: bool = true

func _ready() -> void:
	interaction.on_interact.connect(self._on_switch_toggle)
	
func _on_switch_toggle(player_controller: PlayerController) -> void:
	if !can_switch:
		return
	can_switch = false
	is_on = !is_on
	if is_on:
		if !turned_on:
			video_stream_player.play()
			turned_on = true
		else:
			video_stream_player.paused = false
	else:
		video_stream_player.paused = true
	await get_tree().create_timer(1).timeout
	can_switch = true
