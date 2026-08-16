class_name PlayerActor3D extends Node3D

enum PlayerAnimation {
	IDLE = 0,
	IDLE_RIG = 1,
	RUNNING_RIG = 2,
	STUNNED = 3,
	TAUNT = 4,
	HIDE = 5,
	ATTACK = 6,
	FLY = 7
}

@export var animation_player: AnimationPlayer
@export var player_body_mesh: MeshInstance3D
@export var player_face_mesh: MeshInstance3D
@export var mimico_backpack: Node3D
@export var player_actor_animation_player: AnimationPlayer

@export var color: Color
@export_range(0, 5, 1) var current_face: int = 0
@export_range(0, 5, 1) var animation: int = 0
@export_node_path() var face_look_at: NodePath:
	set(value):
		face_look_at = value
		set_lookup_target(face_look_at)

@export var spring_bone_simulator_3d: SpringBoneSimulator3D
@export var ik_hands_active: bool:
	set(value):
		ik_hands_active = value
		set_active_ik_hands(value)
		
@export var ik_head_active: bool:
	set(value):
		ik_head_active = value
		if !is_ready:
			return
		if ik_head_active:
			set_lookup_target(head_target.get_path())
		else:
			set_lookup_target("")

@export var snap_image: ImageTexture

@export var hand_area_3d: Area3D

@export_group("Actor_Invers_Kinematics")
@export var look_at_modifier_head: LookAtModifier3D
@export var two_bone_ik_3d_left_arm: TwoBoneIK3D
@export var copy_transform_modifier_3d_left_hand: CopyTransformModifier3D
@export var two_bone_ik_3d_right_arm: TwoBoneIK3D
@export var copy_transform_modifier_3d_right_hand: CopyTransformModifier3D

@export_group("Actor_Invers_Kinematics_Targets")
@export var head_target: Marker3D
@export var left_hand_target: Marker3D
@export var right_hand_target: Marker3D

const Face_idle = preload("uid://buchwg7bg7rdw")
const Face_shoked = preload("uid://3c30cs2fx0u8")
const Face_sacred = preload("uid://c4ojhtplo0qkw")
const face_smile = preload("uid://12r3qenu68lm")
const face_stunned = preload("uid://pwmjppqhcijr")
const face_ruben = preload("uid://c3mfw3kul1ppv")

const MAX_FACES: int = 2
const PLAYER_FACE_BASE: StandardMaterial3D = preload("uid://cvff6hkfnq5r6")
const PLAYER_BODY_BASE: StandardMaterial3D = preload("uid://bsava25irrlk1")

var is_ready: bool = false
var tween: Tween
var current_animation: PlayerAnimation = PlayerAnimation.IDLE

var head_look_at_tween: Tween

const animation_map = [
	PlayerAnimation.IDLE,
	PlayerAnimation.IDLE_RIG,
	PlayerAnimation.RUNNING_RIG,
	PlayerAnimation.STUNNED,
	PlayerAnimation.TAUNT,
	PlayerAnimation.HIDE,
	PlayerAnimation.ATTACK,
	PlayerAnimation.FLY,
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	is_ready = true
	set_face(current_face)
	set_lookup_target(face_look_at)

func update_current_animation() -> void:
	set_animation(animation)

func update_current_color() -> void:
	set_color(color)

func update_current_face() -> void:
	set_face(current_face)
	
func update_current_look_at() -> void:
	set_lookup_target(face_look_at)
	
func set_lookup_target(path: NodePath) -> void:
	if !is_ready:
		return
	if look_at_modifier_head.target_node == path:
		return
	if head_look_at_tween:
		head_look_at_tween.stop()
		head_look_at_tween.cancel_free()
	head_look_at_tween = create_tween()
	look_at_modifier_head.target_node = path
	if !path:
		#spring_bone_simulator_3d.active = true
		look_at_modifier_head.active = false
		head_look_at_tween.tween_property(look_at_modifier_head, "influence", 0, 0.2)
	else:
		#spring_bone_simulator_3d.active = false
		look_at_modifier_head.active = true
		head_look_at_tween.tween_property(look_at_modifier_head, "influence", 1, 0.2)
	head_look_at_tween.play()
	

func set_lookup_position(_position: Vector3) -> void:
	head_target.global_position = _position
	look_at_modifier_head.target_node = head_target.get_path()

func set_color(_color: Color) -> void:
	var mat: StandardMaterial3D = get_body_material().duplicate()
	mat.albedo_color = _color
	player_body_mesh.set_surface_override_material(0, mat)

func set_outline(outline: bool) -> void:
	var mat: StandardMaterial3D = get_body_material().duplicate_deep()
	if outline:
		mat.stencil_color = Color.WHITE
	else:
		mat.stencil_color = Color.BLACK
	player_body_mesh.set_surface_override_material(0, mat)

func set_face(face: int) -> void:
	current_face = face
	var face_material = get_face_material()
	var mat: StandardMaterial3D = face_material.duplicate()
	match(face):
		0: mat.albedo_texture = Face_idle
		1: mat.albedo_texture = Face_shoked
		2: mat.albedo_texture = Face_sacred
		3: mat.albedo_texture = face_smile
		4: mat.albedo_texture = face_stunned
		5: mat.albedo_texture = face_ruben
	player_face_mesh.set_surface_override_material(0, mat)

func set_snap_face() -> void:
	var mat: StandardMaterial3D = get_face_material().duplicate()
	if snap_image:
		mat.albedo_texture = snap_image
	else:
		mat.albedo_texture = Face_idle
	player_face_mesh.set_surface_override_material(0, mat)

func set_active_ik_hands(active: bool) -> void:
	if !is_ready:
		return
	two_bone_ik_3d_left_arm.active = active
	copy_transform_modifier_3d_left_hand.active = active
	two_bone_ik_3d_right_arm.active = active
	copy_transform_modifier_3d_right_hand.active = active
	if tween:
		tween.pause()
		tween.cancel_free()
	tween = create_tween()
	var influence: float = 0.0
	if active:
		influence = 1.0
	tween.parallel().tween_property(two_bone_ik_3d_left_arm, "influence", influence, 0.1)
	tween.parallel().tween_property(copy_transform_modifier_3d_left_hand, "influence", influence, 0.1)
	tween.parallel().tween_property(two_bone_ik_3d_right_arm, "influence", influence, 0.1)
	tween.parallel().tween_property(copy_transform_modifier_3d_right_hand, "influence", influence, 0.1)
	

func get_face_material() -> StandardMaterial3D:
	var face_material = player_face_mesh.get_surface_override_material(0)
	if !face_material:
		return PLAYER_FACE_BASE
	return face_material
	
func get_body_material() -> StandardMaterial3D:
	var body_material = player_body_mesh.get_surface_override_material(0)
	if !body_material:
		return PLAYER_BODY_BASE
	return body_material
	

func set_animation(_animation: int) -> void:
	animation = _animation
	if _animation > animation_map.size():
		ApplicationManager.system_log("unknown animation")
		return
	current_animation = animation_map.get(_animation)
	match(current_animation):
		PlayerAnimation.IDLE: 
			animation_player.play("idle")
			#player_actor_animation_player.stop()
		PlayerAnimation.IDLE_RIG: 
			animation_player.play("idle_rig")
			#player_actor_animation_player.stop()
		PlayerAnimation.RUNNING_RIG: 
			animation_player.play("running_rig")
			#player_actor_animation_player.stop()
		PlayerAnimation.STUNNED: 
			animation_player.play("stunned")
			#player_actor_animation_player.stop()
		PlayerAnimation.TAUNT: 
			animation_player.play("taunt_01")
			#player_actor_animation_player.stop()
		PlayerAnimation.HIDE:
			#animation_player.play("fall_rig")
			player_actor_animation_player.play("hide", -1, 2)
		PlayerAnimation.ATTACK: 
			animation_player.play("slap", -1, 2)
			player_actor_animation_player.play("punch", -1, 2)
		PlayerAnimation.FLY: 
			animation_player.play("flying")
		_: 
			animation_player.play("idle")
			
