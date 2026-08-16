extends Node3D

@export var player_controller: PlayerController
@export var input_manager: InputManager

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player_controller.plug_in_input_manager(input_manager)
