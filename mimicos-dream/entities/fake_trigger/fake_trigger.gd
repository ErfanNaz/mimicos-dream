extends Node3D

@export_category("Internal")
@export var interaction: Interaction
@export var animation_player: AnimationPlayer

var is_running: bool = false

var times_clicked: int = 0

func _ready() -> void:
	interaction.on_interact.connect(
		func (player_controller: PlayerController) -> void:
			if is_running:
				return
			is_running = true
			times_clicked += 1
			player_controller.switch_to_state("idle")
			player_controller.player_actor.animation_player.play("idle")
			animation_player.play("animation|on")
			await get_tree().create_timer(1).timeout
			animation_player.play("animation|off")
			player_controller.switch_to_state("third_person")
			is_running = false
	)
