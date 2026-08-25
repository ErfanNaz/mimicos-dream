class_name ItemBase extends Node3D

@export var interact_data: InteractData

@export var interaction: Interaction
@export var mesh: Node3D
@export var item_image: Texture2D

var mesh_animation_player: AnimationPlayer

signal on_play_animation(player_controller: PlayerController, animation: String)
signal on_drop(player_controller: PlayerController, item: ItemBase)
signal on_drag(player_controller: PlayerController, item: ItemBase)

signal on_current_changed(player_controller: PlayerController, is_current: bool)

func _ready() -> void:
	if interact_data:
		interaction.interact_data = interact_data
	interaction.on_interact.connect(self.drag_item)
	if !mesh:
		return
	mesh_animation_player = Utils.find_animation_player_in_glb(mesh)

func play_animation(player_controller: PlayerController, animation: String) -> void:
	if !mesh_animation_player:
		ApplicationManager.warn("could not find a animation player")
		return
	mesh_animation_player.play(animation)
	on_play_animation.emit(player_controller, animation)

func drop_item(player_controller: PlayerController) -> void:
	on_drop.emit(player_controller, self)

func drag_item(player_controller: PlayerController) -> void:
	on_drag.emit(player_controller, self)

func change_current(player_controller: PlayerController, is_current: bool) -> void:
	on_current_changed.emit(player_controller, is_current)
	
