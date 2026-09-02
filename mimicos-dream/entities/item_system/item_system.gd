class_name ItemSystem extends Node

@export var player_controller: PlayerController
@export var item_system_ui: ItemSystemUi

signal on_item_add(player_controller: PlayerController, item: ItemBase)
signal on_item_remove(player_controller: PlayerController, item: ItemBase)
signal on_current_item_changed(player_controller: PlayerController, item: ItemBase)

var current_items: Array[ItemBase] = []
var current_item: ItemBase
var current_item_index: int = 0

var controller_input: ControllerInput

var can_switch_current: bool = true

func _ready() -> void:
	on_current_item_changed.connect(self._on_current_item_changed)
	item_system_ui.show_arrows = false
	set_process(false)

func reset() -> void:
	current_items = []
	current_item = null

func add_item(player_controller: PlayerController, item: ItemBase) -> void:
	if current_items.has(item):
		ApplicationManager.warn("item already picked")
		return
	current_items.append(item)
	on_item_add.emit(player_controller, item)
	current_item = item
	item.change_current(player_controller, true)
	on_current_item_changed.emit(player_controller, current_item)
	item.interaction.deactivate()
	item.mesh.hide()
	_check_activate_process()

func remove_item(player_controller: PlayerController, item: ItemBase) -> void:
	if !current_items.has(item):
		ApplicationManager.warn("item not exists")
		return
	current_items.erase(item)
	on_item_remove.emit(player_controller, item)
	_check_activate_process()
	
	if !current_item == item:
		return
	current_item_index = 0
	var next_item = current_items[current_item_index]
	if !next_item:
		on_current_item_changed.emit(player_controller, null)
		return
	if current_item:
		current_item.change_current(player_controller, false)
	current_item = next_item
	current_item.change_current(player_controller, true)
	on_current_item_changed.emit(player_controller, current_item)
	item.drop_item(player_controller)

func _on_current_item_changed(player_controller: PlayerController, item: ItemBase) -> void:
	if !item:
		item_system_ui.set_texture(null)
		return
	item_system_ui.set_texture(item.item_image)
	var hand: Node3D = player_controller.player_actor.right_hand_item_container
	for child in hand.get_children():
		hand.remove_child(child)
	if !item.mesh_instance:
		return
	var mesh_instance: MeshInstance3D = MeshInstance3D.new()
	mesh_instance.mesh = item.mesh_instance.mesh
	mesh_instance.position = item.hand_position
	mesh_instance.rotation = item.hand_rotation
	mesh_instance.scale = item.hand_scale
	hand.add_child(mesh_instance)

func switch_current_item(index: int) -> bool:
	if index < 0:
		index = current_items.size() - 1
	if index >= current_items.size():
		index = 0
	if index == current_item_index:
		return false
	var next_item: ItemBase = current_items.get(index)
	if next_item == null:
		return false
	current_item.change_current(player_controller, false)
	current_item_index = index
	current_item = next_item
	current_item.change_current(player_controller, true)
	on_current_item_changed.emit(player_controller, current_item)
	return true

func _check_activate_process() -> void:
	if current_items.size() > 1:
		controller_input = player_controller.input_manager.controller_input
		item_system_ui.show_arrows = true
		set_process(true)
	else:
		item_system_ui.show_arrows = false
		set_process(false)

func _process(delta: float) -> void:
	if controller_input.digital_direction.x == 0:
		return
	if controller_input.digital_direction.x > 0:
		switch_current_item_triggered(current_item_index + 1)
	else:
		switch_current_item_triggered(current_item_index - 1)

func switch_current_item_triggered(index: int) -> void:
	if !can_switch_current:
		return
	var switch_to_item: bool = switch_current_item(index)
	if !switch_to_item:
		return
	can_switch_current = false
	await get_tree().create_timer(0.3).timeout
	can_switch_current = true
