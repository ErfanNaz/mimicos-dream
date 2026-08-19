class_name StateBlackboard extends Resource

enum PlayerControllerState {
	idle,
	input_third_person,
	input_top_down
}

@export var controller_state: PlayerControllerState = PlayerControllerState.idle
@export var velocity: Vector3 = Vector3.ZERO
@export var velocity_y: float = 0.0
@export var is_on_floor: bool = true
@export var is_dashing: bool = false
@export_enum("idle","jump","fall","walk","run") var state: String = "idle":
	set(value):
		if value == state:
			return
		on_state_switched.emit(state, value)
		state = value
@export_enum("idle","jump","fall","walk","run") var pre_state: String = "idle"
@export_enum("move","in_air") var selector: String = "move"

signal on_state_switched(from: String, to: String)
