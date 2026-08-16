class_name ControllerInput extends Resource

@export var direction: Vector2 = Vector2.ZERO
@export var lookup_direction: Vector2 = Vector2.ZERO
@export var digital_direction: Vector2 = Vector2.ZERO
@export var force_left: float = 0
@export var force_right: float = 0
@export var buttons: Dictionary = {}
@export var in_menu: bool = false

@export var version: int = 0

static func update_from_diff(current_controller_input: ControllerInput, diff: Dictionary) -> ControllerInput:
	if diff.has("version") && current_controller_input.version != diff.version:
		current_controller_input.set("version", diff.version)
	if diff.has("direction") && current_controller_input.direction != diff.direction:
		current_controller_input.set("direction", diff.direction)
	if diff.has("lookup_direction") && current_controller_input.lookup_direction != diff.lookup_direction:
		current_controller_input.set("lookup_direction", diff.lookup_direction)
	if diff.has("digital_direction") && current_controller_input.digital_direction != diff.digital_direction:
		current_controller_input.set("digital_direction", diff.digital_direction)
	if diff.has("force_left") && current_controller_input.force_left != diff.force_left:
		current_controller_input.set("force_left", diff.force_left)
	if diff.has("force_right") && current_controller_input.force_right != diff.force_right:
		current_controller_input.set("force_right", diff.force_right)
	if diff.has("in_menu") && current_controller_input.in_menu != diff.in_menu:
		current_controller_input.set("in_menu", diff.in_menu)
	if diff.has("buttons"):
		current_controller_input.set("buttons", diff.buttons)
	return current_controller_input
