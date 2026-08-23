extends Node3D

@export var interaction: Interaction
@export var wasser_podest_fertig: Node3D
@export var wasser_podest_2: Node3D


func _ready() -> void:
	interaction.on_interact.connect(self._on_interact)
	
func _on_interact(player_controller: PlayerController) -> void:
	if GameManager.item_system.item_system_ui.current_item.texture:
		GameManager.item_system.item_system_ui.current_item.texture = null
		wasser_podest_2.hide()
		wasser_podest_fertig.show()
