class_name ItemBase extends Node3D

@export var interact_data: InteractData

@export var interaction: Interaction
@export var mesh_instance: MeshInstance3D
@export var item_image: Texture2D

func _ready() -> void:
	if interact_data:
		interaction.interact_data = interact_data

	interaction.on_interact.connect(self._on_interact)
	
func _on_interact(player_controller: PlayerController) -> void:
	GameManager.item_system.item_system_ui.current_item.texture = item_image
	queue_free()
