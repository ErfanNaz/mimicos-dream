extends Node3D

@export var target_element: Node3D:
	set(value):
		target_element = value
		_find_target_animation_player()

@export var trigger_element: Node3D:
	set(value):
		trigger_element = value
		_find_trigger_animation_player()

@export var on_animation: String = "animation|on"
@export var off_animation: String = "animation|off"

@export var interact_data: InteractData

@export_category("trigger settings")
@export_range(0, 100, 1, "prefer_slider") var toggle_back_timer: int = 0

@export_category("Internal")
@export var trigger_target: TriggerTarget
@export var trigger_switch: TriggerSwitch

func _ready() -> void:
	trigger_target.on_animation = on_animation
	trigger_target.off_animation = off_animation
	trigger_switch.toggle_back_timer = toggle_back_timer
	if interact_data:
		trigger_switch.interaction.interact_data = interact_data
	trigger_switch.on_switch.connect(self._on_switch_toggle)
	_find_target_animation_player()
	_find_trigger_animation_player()
	
func _on_switch_toggle(player_controller: PlayerController, on: bool) -> void:
	trigger_target.is_on = on

func _find_trigger_animation_player() -> void:
	if !trigger_element:
		trigger_switch.animation_player = null
		return
	var animation_player: AnimationPlayer = Utils.find_animation_player_in_glb(trigger_element)
	if !animation_player:
		return
	trigger_switch.animation_player = animation_player

func _find_target_animation_player() -> void:
	if !target_element:
		trigger_target.animation_player = null
		return
	var animation_player: AnimationPlayer = Utils.find_animation_player_in_glb(target_element)
	if !animation_player:
		return
	trigger_target.animation_player = animation_player
