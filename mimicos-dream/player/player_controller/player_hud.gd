class_name PlayerHud extends Sprite3D

@export var label: Label

func change_current_gold(current_gold: int) -> void:
	label.text = str(current_gold)
