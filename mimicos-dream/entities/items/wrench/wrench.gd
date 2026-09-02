extends Node3D

@export var inventar_texture: Texture2D

@export_category("Internal")
@export var item: ItemBase

func _ready() -> void:
	item.on_drag.connect(self._on_drag)
	item.item_image = inventar_texture
	set_process(false)

func _on_drag(player_controller: PlayerController, _item: ItemBase) -> void:
	GameManager.item_system.add_item(player_controller, _item)
