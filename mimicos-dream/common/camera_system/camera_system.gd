class_name CameraSystem extends Node3D

@export var camera_3d: Camera3D
@export var phantom_camera_3d: PhantomCamera3D
@export var anchor_node: Node3D

@export var camera_position_target: Node3D
@export var target_spring_arm_3d: SpringArm3D
@export var look_at_target: Node3D
@export var camera_anchor: Node3D

@export var min_distance: float = 1
@export_range(1, 30, 1) var follow_speed: float = 6

var initial_anchor_transform: Transform3D

func _ready() -> void:
	GameManager.camera_system = self
	initial_anchor_transform = anchor_node.transform
	set_process(false)


func _process(_delta: float) -> void:
	if !camera_position_target:
		set_process(false)
		return
	global_position = camera_position_target.global_position

func reset() -> void:
	anchor_node.transform = initial_anchor_transform
