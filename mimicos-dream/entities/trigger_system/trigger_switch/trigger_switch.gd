class_name TriggerSwitch extends Node3D

@export_range(0, 100, 1, "prefer_slider") var toggle_back_timer: int = 0
@export var animation_player: AnimationPlayer

@export_category("internal")
@export var interaction: Interaction
@export var ball_mesh_instance_3d: MeshInstance3D
@export var sprite_3d: Sprite3D
@export var label: Label

signal on_switch(player_controller: PlayerController, on: bool)

var last_player: PlayerController
var is_on: bool = false

func _ready() -> void:
	interaction.on_interact.connect(self._toggle_trigger)
	var mat: StandardMaterial3D = ball_mesh_instance_3d.get_surface_override_material(0).duplicate()
	ball_mesh_instance_3d.set_surface_override_material(0, mat)

func _toggle_trigger(player_controller: PlayerController) -> void:
	if is_on:
		return
	is_on = true
	on_switch.emit(player_controller, true)
	if animation_player:
		animation_player.play("animation|on")
	var mat: StandardMaterial3D = ball_mesh_instance_3d.get_surface_override_material(0)
	var color: Color = player_controller.get_player_color(player_controller.team)
	mat.emission = color
	await get_tree().create_timer(1).timeout
	if toggle_back_timer > 0:
		sprite_3d.show()
		last_player = player_controller
		_auto_close(toggle_back_timer)
		return
	is_on = false
	on_switch.emit(player_controller, false)
	mat.emission = Color.WHITE
	if animation_player:
		animation_player.play("animation|off")
	
func _auto_close(timer: int) -> void:
	if timer <= 0:
		timer = 0
		label.text = ""
		is_on = false
		on_switch.emit(last_player, false)
		var mat: StandardMaterial3D = ball_mesh_instance_3d.get_surface_override_material(0)
		mat.emission = Color.WHITE
		sprite_3d.hide()
		if animation_player:
			animation_player.play("animation|off")
		return
	label.text = str(timer)
	await get_tree().create_timer(1).timeout
	_auto_close(timer - 1)
