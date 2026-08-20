extends RigidBody3D

@export var damage: int = 0
@export var stun_time: int = 1

@export_category("Internal")
@export var interaction: Interaction
@export var lifetime_timer: Timer

var current_player: PlayerController
var pre_state: String

func _ready() -> void:
	interaction.on_interact.connect(self._on_player_entered)
	lifetime_timer.timeout.connect(self._on_finished)

func _on_player_entered(player_controller: PlayerController) -> void:
	if current_player == player_controller:
		return
	current_player = player_controller
	pre_state = player_controller.get_controller_state()
	player_controller.switch_to_state("idle")
	await get_tree().create_timer(stun_time).timeout
	_on_finished()
	 
func _on_finished() -> void:
	if !current_player:
		queue_free()
		return
	current_player.switch_to_state(pre_state)
