class_name InteractData extends Resource

enum InteractableType {
	entity,
	player
}

@export var title: String = ""
@export var type: InteractableType = InteractableType.entity
@export_range(-1, 12, 1, "prefer_slider") var action_button: int = -1
