extends Node3D

@export_category("Internal")
@export var animation_player: AnimationPlayer
@export var interaction: Interaction


var is_open: bool = false

func _ready() -> void:
	interaction.on_player_entered.connect(self._on_player_entered)
	interaction.on_player_exited.connect(self.on_player_exited)
	
func _on_player_entered(_interaction: Interaction) -> void:
	if is_open:
		return
	is_open = true
	animation_player.play("animation|on")

func on_player_exited(_interaction: Interaction) -> void:
	if !is_open:
		return
	is_open = false
	animation_player.play("animation|off")
