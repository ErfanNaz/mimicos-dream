extends Node3D

@export var text: String = ""
@export var interact_data: InteractData

@export_category("trigger settings")
@export_range(0, 100, 1, "prefer_slider") var toggle_back_timer: int = 0

@export var one_shot: bool = true

@export_category("Internal")
@export var trigger_switch: TriggerSwitch
@export var animation_player: AnimationPlayer
@export var text_label: Label

var preview_state: String

func _ready() -> void:
	trigger_switch.toggle_back_timer = toggle_back_timer
	text_label.text = text
	if interact_data:
		trigger_switch.interaction.interact_data = interact_data
	trigger_switch.on_switch.connect(self._on_switch_toggle)
	
func _on_switch_toggle(_player_controller: PlayerController, on: bool) -> void:
	if on:
		animation_player.play("show")
	else:
		if one_shot:
			queue_free()
	
