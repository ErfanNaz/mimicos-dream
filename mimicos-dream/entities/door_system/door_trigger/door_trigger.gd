class_name DoorTrigger extends Node3D

@export var door: Door
@export var mesh_instance_3d: MeshInstance3D
@export var interaction: Interaction

@export_range(0, 10, 1, "prefer_slider") var toggle_back_timer: int = 0
@export var label: Label
@export var sprite_3d: Sprite3D

var input_ingore: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	interaction.on_interact.connect(self._toggle_door)
	var mat: StandardMaterial3D = mesh_instance_3d.get_surface_override_material(0).duplicate()
	mesh_instance_3d.set_surface_override_material(0, mat) 

func _toggle_door(_player_controller: PlayerController) -> void:
	if !door:
		return
	if input_ingore:
		return
	input_ingore = true
	door.is_open = !door.is_open
	var mat: StandardMaterial3D = mesh_instance_3d.get_surface_override_material(0)
	var color: Color = _player_controller.get_player_color(_player_controller.team)
	mat.emission = color
	await get_tree().create_timer(1).timeout
	if toggle_back_timer > 0:
		sprite_3d.show()
		_auto_close(toggle_back_timer)
		return
	input_ingore = false
	mat.emission = Color.WHITE
	
func _auto_close(timer: int) -> void:
	if timer <= 0:
		timer = 0
		label.text = ""
		door.is_open = !door.is_open
		input_ingore = false
		var mat: StandardMaterial3D = mesh_instance_3d.get_surface_override_material(0)
		mat.emission = Color.WHITE
		sprite_3d.hide()
		return
	label.text = str(timer)
	await get_tree().create_timer(1).timeout
	_auto_close(timer - 1)
