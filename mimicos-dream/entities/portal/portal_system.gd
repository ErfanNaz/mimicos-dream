extends Node3D

@export_category("Internal")
@export var portal: Portal
@export var portal_2: Portal


func _ready() -> void:
	portal.portal_player.connect(self._portal_player)
	portal_2.portal_player.connect(self._portal_player)

func _portal_player(player_controller: PlayerController, from: Portal, to: Portal) -> void:
	player_controller.player_actor.hide()
	await get_tree().create_timer(0.5).timeout
	player_controller.player_body.global_position = to.spawn_marker_3d.global_position
	await get_tree().create_timer(1).timeout
	player_controller.player_actor.show()
