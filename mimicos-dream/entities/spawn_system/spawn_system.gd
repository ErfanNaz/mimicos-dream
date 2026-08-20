extends Node3D

@export var spawn_p_path_follow_3d: Path3D
@export var spawn_t_path_follow_3d: Path3D
@export_range(1, 100, 1, "prefer_slider") var spawn_velocity_multiplayer: float = 10.0
@export_range(1, 10, 1, "prefer_slider") var amount_per_second: int = 1

@export var spawn_scene: PackedScene
@export var one_shot: bool = false

@export_range(0, 100, 1, "prefer_slider") var toggle_back_timer: int = 0

@export_category("Internal")
@export var multiplayer_spawner: MultiplayerSpawner
@export var trigger_switch: TriggerSwitch
@export var spawn_timer: Timer
@export var animation_player: AnimationPlayer
@export var spawn_marker_3d: Marker3D
@export var target_marker_3d: Marker3D
@export var spawn_start_path_3d: Path3D
@export var spawn_velocity_path_3d: Path3D

func _ready() -> void:
	multiplayer_spawner.spawn_function = self._multiplayer_spawn_func
	trigger_switch.on_switch.connect(self._on_switch_toggle)
	spawn_timer.timeout.connect(self._on_spawn_entity)
	spawn_start_path_3d.curve = spawn_p_path_follow_3d.curve
	spawn_velocity_path_3d.curve = spawn_t_path_follow_3d.curve
	trigger_switch.toggle_back_timer = toggle_back_timer
	if amount_per_second > 1:
		var wait_time = 1.0 / float(amount_per_second)
		spawn_timer.wait_time = wait_time
	else:
		ApplicationManager.warn("amount per second must be 1 or bigger")
	
func _on_switch_toggle(_player_controller: PlayerController, on: bool) -> void:
	if on:
		spawn_timer.start()
		animation_player.play("idle")
	else:
		spawn_timer.stop()
		animation_player.stop()
		if one_shot:
			queue_free()

func _on_spawn_entity() -> void:
	var _position = spawn_marker_3d.global_position
	var velocity = spawn_marker_3d.global_position.direction_to(target_marker_3d.global_position) 
	var entity: RigidBody3D = multiplayer_spawner.spawn({
		"position": _position,
		"velocity": velocity
	})
	entity.global_position = _position
	entity.linear_velocity = velocity * spawn_velocity_multiplayer

func _multiplayer_spawn_func(data: Dictionary) -> Node3D:
	var entity = spawn_scene.instantiate()
	ApplicationManager.system_log("spawn entity:%s with data:" % [entity.name], data)
	return entity
