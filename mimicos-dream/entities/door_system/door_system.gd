extends Node3D

@export var can_open: bool = true

@export_category("Internal")
@export var animation_player: AnimationPlayer
@export var trigger_switch: TriggerSwitch
@export var static_body_3d: StaticBody3D

signal on_open(player_controller: PlayerController)

var is_open: bool = false

func _ready() -> void:
	trigger_switch.on_switch.connect(self._on_trigger_switch)
	
func _on_trigger_switch(player_controller: PlayerController, on: bool) -> void:
	if !on:
		return
	if is_open:
		return
	if !can_open:
		return
	is_open = true
	animation_player.play("animation|on")
	on_open.emit(player_controller)
	static_body_3d.queue_free()
