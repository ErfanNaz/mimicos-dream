extends Node3D

@export var player_controller: PlayerController
@export var input_manager: InputManager
@export var start_marker_3d: Marker3D
@export var item_system: ItemSystem
@export var animation_player: AnimationPlayer

@export_range(0, 5, 1, "prefer_slider") var log_level: int = 2:
	set(value):
		log_level = value
		ApplicationManager.log_level = log_level

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player_controller.plug_in_input_manager(input_manager)
	ApplicationManager.log_level = log_level
	player_controller.input_active_state_machine()
	player_controller.player_actor.disable_outline()
	GameManager.camera_system.phantom_camera_3d.set_look_at_target(player_controller.look_at_target_node_3d)
	player_controller.player_body.global_position = start_marker_3d.global_position
	GameManager.item_system = item_system
