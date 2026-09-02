extends Node3D

@export var player_controller: PlayerController
@export var input_manager: InputManager
@export var map: Node3D
@export var item_system: ItemSystem
@export var minigame_system: MinigameSystem
@export var camera_system: CameraSystem

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
	GameManager.camera_system = camera_system
	GameManager.camera_system.phantom_camera_3d.set_look_at_target(player_controller.look_at_target_node_3d)
	if !map || !map.start_marker_3d:
		return
	var start_marker_3d: Node3D = map.start_marker_3d
	player_controller.player_body.global_position = start_marker_3d.global_position
	GameManager.current_player_controller = player_controller
	GameManager.item_system = item_system
	GameManager.minigame_system = minigame_system
	
	check_node(self)


func check_node(node: Node):
	if node is Area3D or node is CollisionShape3D or node is StaticBody3D or node is RigidBody3D or node is CharacterBody3D:
		var scale: Vector3 = node.global_transform.basis.get_scale()

		var non_uniform := (
			not is_equal_approx(scale.x, scale.y)
			or not is_equal_approx(scale.x, scale.z)
			or not is_equal_approx(scale.y, scale.z)
		)

		if non_uniform:
			print("⚠️ JOLT SCALE PROBLEM")
			print("   Node: ", node.get_path())
			print("   Scale: ", scale)

	for child in node.get_children():
		check_node(child)
