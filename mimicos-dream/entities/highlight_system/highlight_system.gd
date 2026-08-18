class_name HighlightSystem extends Node3D

@export var target_element: Node3D
@export var interact_data: InteractData

@export var one_shot: bool = false

@export_category("trigger settings")
@export_range(0, 100, 1, "prefer_slider") var toggle_back_timer: int = 0

@export_category("Internal")
@export var trigger_switch: TriggerSwitch

var current_target: Node3D

func _ready() -> void:
	trigger_switch.toggle_back_timer = toggle_back_timer
	if interact_data:
		trigger_switch.interaction.interact_data = interact_data
	trigger_switch.on_switch.connect(self._on_switch_toggle)
	
func _on_switch_toggle(player_controller: PlayerController, on: bool) -> void:
	if on:
		player_controller.idle_state_machine()
		player_controller.player_actor.set_animation("idle")
		current_target = player_controller.phantom_camera_3d.get_look_at_target()
		if !current_target:
			ApplicationManager.warn("missing phantom camera target")
			return
		player_controller.phantom_camera_3d.set_look_at_target(target_element)
	else:
		player_controller.input_active_state_machine()
		if !current_target:
			ApplicationManager.warn("missing phantom camera target")
			return
		player_controller.phantom_camera_3d.set_look_at_target(current_target)
		if one_shot:
			queue_free()
