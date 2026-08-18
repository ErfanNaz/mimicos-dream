class_name TriggerSwitch extends Node3D

@export var trigger_element: Node3D:
	set(value):
		trigger_element = value
		_find_animation_player()
@export_range(0, 10, 1, "prefer_slider") var toggle_back_timer: int = 0

@export_category("internal")
@export var interaction: Interaction
@export var ball_mesh_instance_3d: MeshInstance3D
@export var sprite_3d: Sprite3D
@export var label: Label

signal on_switch(on: bool)

var founded_animation_player: AnimationPlayer

var is_on: bool = false

func _ready() -> void:
	interaction.on_interact.connect(self._toggle_trigger)
	var mat: StandardMaterial3D = ball_mesh_instance_3d.get_surface_override_material(0).duplicate()
	ball_mesh_instance_3d.set_surface_override_material(0, mat)
	_find_animation_player()

func _find_animation_player() -> void:
	if !trigger_element:
		founded_animation_player = null
		return
	for child in trigger_element.get_children():
		if child is AnimationPlayer:
			founded_animation_player = child
			break

func _toggle_trigger(_player_controller: PlayerController) -> void:
	if is_on:
		return
	is_on = true
	on_switch.emit(true)
	if founded_animation_player:
		founded_animation_player.play("animation|on")
	var mat: StandardMaterial3D = ball_mesh_instance_3d.get_surface_override_material(0)
	var color: Color = _player_controller.get_player_color(_player_controller.team)
	mat.emission = color
	await get_tree().create_timer(1).timeout
	if toggle_back_timer > 0:
		sprite_3d.show()
		_auto_close(toggle_back_timer)
		return
	is_on = false
	on_switch.emit(false)
	mat.emission = Color.WHITE
	if founded_animation_player:
		founded_animation_player.play("animation|off")
	
func _auto_close(timer: int) -> void:
	if timer <= 0:
		timer = 0
		label.text = ""
		is_on = false
		on_switch.emit(false)
		var mat: StandardMaterial3D = ball_mesh_instance_3d.get_surface_override_material(0)
		mat.emission = Color.WHITE
		sprite_3d.hide()
		if founded_animation_player:
			founded_animation_player.play("animation|off")
		return
	label.text = str(timer)
	await get_tree().create_timer(1).timeout
	_auto_close(timer - 1)
