extends Node3D

@export var start_marker_3d: Marker3D
@export var portal: Portal
@export var portal_2: Portal

var hit_ones: bool = false

func _ready() -> void:
	portal.portal_player.connect(self._portal_player)
	portal_2.portal_player.connect(self._portal_player)
	await get_tree().create_timer(2).timeout
	GameManager.current_player_controller.player_interactable.on_player_hit.connect(self._on_player_hit)
	
func _portal_player(player_controller: PlayerController, from: Portal, to: Portal) -> void:
	player_controller.player_actor.hide()
	await get_tree().create_timer(0.5).timeout
	player_controller.player_body.global_position = to.spawn_marker_3d.global_position
	await get_tree().create_timer(1).timeout
	player_controller.player_actor.show()
	
func _on_player_hit(player_controller: PlayerController, interaction: Interaction) -> void:
	var player_state = player_controller.get_controller_state()
	if player_state == "idle":
		return
	if hit_ones:
		hit_ones = false
		player_controller.player_body.global_position = start_marker_3d.global_position
		return
	hit_ones = true
	player_controller.switch_to_state("idle")
	player_controller.player_body.velocity = Vector3.ZERO
	await get_tree().create_timer(2).timeout
	player_controller.switch_to_state(player_state)
