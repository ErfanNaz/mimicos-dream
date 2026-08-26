class_name ItemSystemUi extends Control

@export var show_arrows: bool = true:
	set(value):
		if value == show_arrows:
			return
		show_arrows = value
		left_arrow.visible = show_arrows
		right_arrow.visible = show_arrows
		

@export_category("Internal")
@export var current_item: TextureRect
@export var left_arrow: CenterContainer
@export var right_arrow: CenterContainer

func set_texture(texture: Texture2D) -> void:
	current_item.texture = texture
