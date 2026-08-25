extends Node3D

@export_category("Internal")
@export var item: ItemBase
@export var has_details: bool = false
@export var animation_player: AnimationPlayer
@export var canvas_layer: CanvasLayer

var input_manager: InputManager
var detail_change_locked: bool = false

func _ready() -> void:
	item.on_drag.connect(self._on_drag)
	item.on_current_changed.connect(self._on_current_changed)
	set_process(false)

func _on_drag(player_controller: PlayerController, _item: ItemBase) -> void:
	GameManager.item_system.add_item(player_controller, _item)

func _on_current_changed(player_controller: PlayerController, is_current: bool) -> void:
	set_process(is_current)
	input_manager = player_controller.input_manager
	

func _process(delta: float) -> void:
	if input_manager.is_action_pressed(3):
		_toggle_detail()

func _toggle_detail() -> void:
	if detail_change_locked:
		return
	detail_change_locked = true
	var animation: String = "on_show"
	if canvas_layer.visible == true:
		animation = "on_hide"
	animation_player.play(animation)
	await get_tree().create_timer(1).timeout
	detail_change_locked = false
