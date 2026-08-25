extends Node3D

@export var door_pin: String = ""
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
	if door_pin && door_pin != "":
		GameManager.minigame_system.minigame_data = door_pin
		GameManager.minigame_system.on_close_minigame.connect(self._on_close_minigame)
		GameManager.minigame_system.open_minigame(MinigameSystem.MinigameType.door_lock_number, player_controller)
		return
	is_open = true
	animation_player.play("animation|on")
	on_open.emit(player_controller)
	static_body_3d.queue_free()

func _on_close_minigame(player_controller: PlayerController, _minigame) -> void:
	GameManager.minigame_system.on_close_minigame.disconnect(self._on_close_minigame)
	if !GameManager.minigame_system.minigame_succeed:
		return
	is_open = true
	animation_player.play("animation|on")
	on_open.emit(player_controller)
	static_body_3d.queue_free()
