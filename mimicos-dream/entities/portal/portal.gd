class_name Portal extends Node3D

@export var spawn_marker_3d: Marker3D
@export var connected_portal: Portal
@export var interaction: Interaction

@export var mesh_instance_3d: MeshInstance3D

signal portal_player(player_controller: PlayerController, from: Portal, to: Portal)

var players_in_area: Array[PlayerController] = []

const DELAY: float = 3.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	interaction.on_player_entered.connect(self._on_player_entered)
	interaction.on_player_exited.connect(self._on_player_exited)


func _on_player_entered(interaction: Interaction) -> void:
	var player_controller: PlayerController = GameManager.current_player_controller
	players_in_area.append(player_controller)
	check_after_delay_seconds(player_controller)
	var mat: StandardMaterial3D = mesh_instance_3d.get_surface_override_material(0)
	var color: Color = player_controller.get_player_color(player_controller.team)
	mat.emission = color


func _on_player_exited(interaction: Interaction) -> void:
	var player_controller: PlayerController = GameManager.current_player_controller
	players_in_area.erase(player_controller)
	if !players_in_area.is_empty():
		return
	_reset_light()

func check_after_delay_seconds(player_controller: PlayerController):
	await get_tree().create_timer(DELAY).timeout

	if players_in_area.has(player_controller):
		var still_in: bool = false
		for area in interaction.get_overlapping_areas():
			if area == player_controller.player_interactable.player_interaction:
				still_in = true
				break
		if still_in:
			portal_player.emit(player_controller, self, connected_portal)
	players_in_area.erase(player_controller)
	if !players_in_area.is_empty():
		return
	_reset_light()

func _reset_light() -> void:
	var mat: StandardMaterial3D = mesh_instance_3d.get_surface_override_material(0)
	mat.emission = Color.WHITE
