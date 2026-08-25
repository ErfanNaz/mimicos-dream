class_name ItemSystem extends Node

@export var item_system_ui: ItemSystemUi


signal on_item_add(player_controller: PlayerController, item: ItemBase)
signal on_item_remove(player_controller: PlayerController, item: ItemBase)
signal on_current_item_changed(player_controller: PlayerController ,item: ItemBase)

var current_items: Array[ItemBase] = []
var current_item: ItemBase

func _ready() -> void:
	on_current_item_changed.connect(self._on_current_item_changed)

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
	

func remove_item(player_controller: PlayerController, item: ItemBase) -> void:
	if !current_items.has(item):
		ApplicationManager.warn("item not exists")
		return
	current_items.erase(item)
	on_item_remove.emit(player_controller, item)
	if !current_item == item:
		return
	var next_item = current_items[0]
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
		item_system_ui.current_item.texture = null
		return
	item_system_ui.current_item.texture = current_item.item_image
