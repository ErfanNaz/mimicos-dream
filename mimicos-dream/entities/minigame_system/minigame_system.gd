class_name MinigameSystem extends Node

enum MinigameType {
	door_lock_number,
	detail_view
}

@export_category("Internal")
@export var minigame_01: Control
@export var background: ColorRect

var minigame_data: Variant
var minigame_succeed: bool = false
var minigame_success_data: Variant
var minigame_fail_data: Variant

signal on_open_minigame(player_controller: PlayerController, minigame: MinigameType)
signal on_close_minigame(player_controller: PlayerController, minigame: MinigameType)

var current_minigame_control: Control
var current_minigame: MinigameType
var has_current_minigame: bool = false
var player_controller: PlayerController

func open_minigame(minigame: MinigameType, _player_controller: PlayerController) -> void:
	if has_current_minigame:
		return
	player_controller = _player_controller
	player_controller.switch_to_state("idle")
	current_minigame = minigame
	has_current_minigame = true
	background.show()
	match(minigame):
		MinigameType.door_lock_number: 
			minigame_01.on_activate()
			on_open_minigame.emit(player_controller, minigame)
		
func close_minigame() -> void:
	if !has_current_minigame:
		return
	has_current_minigame = false
	player_controller.switch_to_state("third_person")
	background.hide()
	match(current_minigame):
		MinigameType.door_lock_number: 
			minigame_01.on_deactivate()
			on_close_minigame.emit(player_controller, current_minigame)
