extends Node3D

@export var on_animation: String = "animation|open"
@export var off_animation: String = "animation|close"
@export var animation_player: AnimationPlayer

@export_category("trigger settings")
@export_range(0, 10, 1, "prefer_slider") var toggle_back_timer: int = 0
@export var trigger_element: Node3D

@export_category("Internal")
@export var trigger_target: TriggerTarget
@export var trigger_switch: TriggerSwitch

func _ready() -> void:
	trigger_target.on_animation = on_animation
	trigger_target.off_animation = off_animation
	trigger_target.animation_player = animation_player
	trigger_switch.toggle_back_timer = toggle_back_timer
	trigger_switch.trigger_element = trigger_element
	trigger_switch.on_switch.connect(self._on_switch_toggle)
	
func _on_switch_toggle(on: bool) -> void:
	trigger_target.is_on = on
