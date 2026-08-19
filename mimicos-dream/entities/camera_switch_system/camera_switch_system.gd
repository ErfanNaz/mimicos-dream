class_name CameraSwitchSystem extends Node3D

@export_enum("third_person", "top_down", "idle") var toState: String = "third_person"
@export var interact_data: InteractData

@export_enum("default", "up", "down", "left", "right") var direction: String = "default" 

@export_category("trigger settings")
@export_range(0, 100, 1, "prefer_slider") var toggle_back_timer: int = 0

@export var one_shot: bool = true
@export var switch_back: bool = true

@export_category("Internal")
@export var trigger_switch: TriggerSwitch

var preview_state: String

func _ready() -> void:
	trigger_switch.toggle_back_timer = toggle_back_timer
	if interact_data:
		trigger_switch.interaction.interact_data = interact_data
	trigger_switch.on_switch.connect(self._on_switch_toggle)
	
func _on_switch_toggle(player_controller: PlayerController, on: bool) -> void:
	if on:
		preview_state = player_controller.get_controller_state()
		match(toState):
			"idle": player_controller.switch_to_state("idle")
			"top_down": _on_switch_top_down(player_controller)
			"third_person": player_controller.switch_to_state("third_person")
			_: player_controller.switch_to_state("third_person")
	else:
		if switch_back:
			player_controller.switch_to_state(preview_state)
		if one_shot:
			queue_free()
	

func _on_switch_top_down(player_controller: PlayerController) -> void:
	player_controller.switch_to_state("top_down")
	if direction == "default":
		return
	match(direction):
		"up": player_controller.target_anchor_node_3d.rotation.y = 0
		"down": player_controller.target_anchor_node_3d.rotation.y = deg_to_rad(180)
		"left": player_controller.target_anchor_node_3d.rotation.y = deg_to_rad(90)
		"right": player_controller.target_anchor_node_3d.rotation.y = deg_to_rad(270)
