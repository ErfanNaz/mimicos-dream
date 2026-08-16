class_name CameraSystem extends Node3D

@export var camera_3d: Camera3D
@export var phantom_camera_3d: PhantomCamera3D

@export var camera_position_target: Node3D
@export var look_at_target: Node3D
@export var camera_anchor: Node3D

@export var min_distance: float = 1
@export_range(1, 30, 1) var follow_speed: float = 6

@export var animation_player: AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.camera_system = self
	#set_process(false)

func _process(_delta: float) -> void:
	if !camera_position_target:
		set_process(false)
		return
	global_position = camera_position_target.global_position
