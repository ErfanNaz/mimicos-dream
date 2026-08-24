extends Node3D

@export var start_marker_3d: Marker3D
@export var interaction: Interaction
@export var fake_trigger: Node3D
@export var text_system_3: TextSystem

@export var portals: Node3D

var hit_ones: bool = false

func _ready() -> void:
	for portal: Portal in portals.get_children():
		portal.portal_player.connect(self._portal_player)
	await get_tree().create_timer(2).timeout
	GameManager.current_player_controller.player_interactable.on_player_hit.connect(self._on_player_hit)
	text_system_3.on_show.connect(self._on_show_text)

func _on_show_text(player_controller: PlayerController) -> void:
	var times_clicked: int = fake_trigger.times_clicked
	match(times_clicked) :
		0: text_system_3.text_label.text = "This is not the first time you’re playing this, right?"
		1: text_system_3.text_label.text = "You’re learning quick!"
		_: text_system_3.text_label.text = "It took you %d tries to learn it?" % [times_clicked]
		

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
