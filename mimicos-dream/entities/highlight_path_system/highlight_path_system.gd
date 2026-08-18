class_name CameraPathSystem extends Node3D

@export var camera_target_path_follow_3d: PathFollow3D
@export var camera_position_path_follow_3d: PathFollow3D

@export var camera_target: Node3D
@export var camera_position_target: Node3D

@export var interact_data: InteractData

@export_range(0, 100, 1, "prefer_slider") var toggle_back_timer: int = 0

@export var one_shot: bool = false

@export_category("Internal")
@export var trigger_switch: TriggerSwitch
@export var phantom_camera_3d: PhantomCamera3D

var _is_playing: bool = false

func _ready() -> void:
	trigger_switch.toggle_back_timer = toggle_back_timer
	if interact_data:
		trigger_switch.interaction.interact_data = interact_data
	trigger_switch.on_switch.connect(self._on_switch_toggle)

func _on_switch_toggle(player_controller: PlayerController, on: bool) -> void:
	if on:
		player_controller.idle_state_machine()
		player_controller.player_actor.set_animation("idle")
		phantom_camera_3d.set_priority(3)
		start()
	else:
		player_controller.input_active_state_machine()
		phantom_camera_3d.set_priority(0)
		if one_shot:
			queue_free()

func start() -> void:
	if _is_playing:
		return

	_is_playing = true

	camera_target_path_follow_3d.progress_ratio = 0.0
	camera_position_path_follow_3d.progress_ratio = 0.0

	var tween := create_tween()

	tween.set_parallel(true)

	tween.tween_property(
		camera_target_path_follow_3d,
		"progress_ratio",
		1.0,
		toggle_back_timer
	)

	tween.tween_property(
		camera_position_path_follow_3d,
		"progress_ratio",
		1.0,
		toggle_back_timer
	)

	tween.set_parallel(false)

	tween.tween_callback(_on_playback_finished)


func _on_playback_finished() -> void:
	_is_playing = false
