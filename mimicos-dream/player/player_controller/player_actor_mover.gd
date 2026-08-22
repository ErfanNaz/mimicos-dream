class_name PlayerActorMover extends Node

@export var player_controller: PlayerController
@export_range(10, 40, 1, "prefer_slider") var rotation_speed: float = 10.0

var is_conntect: bool = false

var animation_duration: float = 0.15

var animation_tween: Tween
var animation_tween_rotation: Tween

var prev_pos
var curr_pos: Vector3 = Vector3.ZERO

var body: PlayerBody
var actor: PlayerActor3D

func _ready() -> void:
	if !is_conntect:
		set_physics_process(false)

func activated() -> void:
	if is_conntect:
		return
	is_conntect = true
	body = player_controller.player_body
	actor = player_controller.player_actor
	set_physics_process(true)
	
func deactivate() -> void:
	if !is_conntect:
		return
	is_conntect = false
	set_physics_process(false)

func _show_hud_changed(show_hud: bool) -> void:
	if show_hud:
		player_controller.player_hud.show()
	else:
		player_controller.player_hud.hide()

func _physics_process(delta: float) -> void:
	var render_pos = actor.global_position.lerp(body.global_position, 0.2 + delta)
	actor.global_position = render_pos
	
	var current_y_rotation = actor.rotation.y
	
	var new_y_rotation = lerp_angle(
		current_y_rotation,
		body.rotation.y,
		rotation_speed * delta
	)
	
	actor.rotation.y = new_y_rotation
