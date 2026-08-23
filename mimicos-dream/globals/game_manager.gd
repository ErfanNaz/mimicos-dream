extends Node

var camera_system: CameraSystem:
	set (value):
		if value == camera_system:
			return
		camera_system = value
		camera_system_changed.emit(camera_system)

var current_player_controller: PlayerController:
	set (value):
		if value == current_player_controller:
			return
		current_player_controller = value
		current_player_controller_changed.emit(current_player_controller)

var current_input_manager: InputManager:
	set (value):
		if value == current_input_manager:
			return
		current_input_manager = value
		current_input_manager_changed.emit(current_input_manager)

var item_system: ItemSystem:
	set (value):
		if value == item_system:
			return
		item_system = value
		item_system_changed.emit(item_system)

signal camera_system_changed(camera_system: CameraSystem)
signal current_player_controller_changed(current_player_controller: PlayerController)
signal current_input_manager_changed(current_input_manager: InputManager)
signal item_system_changed(item_system: ItemSystem)

var player_controllers: Dictionary[String, PlayerController] = {}
