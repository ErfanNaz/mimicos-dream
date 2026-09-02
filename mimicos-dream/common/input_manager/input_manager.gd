class_name InputManager extends Node

@export var direction_actions: Array[String] = ["move_left", "move_right", "move_up", "move_down"]
@export var lookup_direction_actions: Array[String] = ["lookup_left", "lookup_right", "lookup_up", "lookup_down"]
@export var digital_direction_actions: Array[String] = ["d_left", "d_right", "d_up", "d_down"]
@export var button_actions: Array[String] = ["A", "B", "X", "Y", "LB", "RB"]
@export var force_actions: Array[String] = ["force_left", "force_right"]
@export var menu_button_actions: Array[String] = ["option_button", "start_button"]

@export var enable_lookup_direction: bool = false
@export var enable_digital_direction: bool = false
@export var enable_forces: bool = false

@export var has_input_process: bool = false
@export var player_id: int = 1
@export var active: bool = true

const BUTTON_STATE_RELEASED: float = 0.0
const BUTTON_STATE_JUST_PRESSED: float = 1.0
const BUTTON_STATE_HELD: float = 0.7
const HOLD_THRESHOLD: float = 0.6

const joy_button_actions: Array[JoyButton] = [JOY_BUTTON_A, JOY_BUTTON_B, JOY_BUTTON_X, JOY_BUTTON_Y, JOY_BUTTON_LEFT_SHOULDER, JOY_BUTTON_RIGHT_SHOULDER]

signal controller_input_changed(controller_input: ControllerInput)
signal toggle_menu(is_menu_open: bool)
signal input_process(delta: float)

var controller_input: ControllerInput = ControllerInput.new()

func _ready() -> void:
	if !active:
		set_process(false)
	ApplicationManager.application_focuse_changed.connect(
		func (focus_active: bool) -> void:
			active = focus_active
	)

func activate() -> void:
	set_process(true)

func deactivate() -> void:
	set_process(false)

func is_action_pressed(action: int) -> bool:
	return controller_input.buttons.get(action, BUTTON_STATE_RELEASED) > BUTTON_STATE_RELEASED

func is_action_holded(action: int) -> bool:
	return controller_input.buttons.get(action, BUTTON_STATE_RELEASED) >= HOLD_THRESHOLD

func _process(delta: float) -> void:
	if has_input_process:
		input_process.emit(delta)
		return
	if !active:
		return

	var diff: Dictionary = {
		"version": controller_input.version + 1
	}
	var has_changed: bool = false

	var direction: Vector2 = Input.get_vector(direction_actions[0], direction_actions[1], direction_actions[2], direction_actions[3])
	if controller_input.direction != direction:
		if direction == Vector2.ZERO:
			ApplicationManager.system_log("direction changed version %s direction from %s to %s " % [controller_input.version, controller_input.direction, direction])
		diff.set("direction", direction)
		has_changed = true

	var has_button_changed: bool = false
	var buttons_diff: Dictionary = {}
	for index in button_actions.size():
		var button_action: String = button_actions[index]
		var prev_state: float = controller_input.buttons.get(index, BUTTON_STATE_RELEASED)
		var action_triggered: bool = Input.is_action_pressed(button_action)

		if action_triggered and prev_state == BUTTON_STATE_RELEASED:
			buttons_diff.set(index, BUTTON_STATE_JUST_PRESSED)
			has_button_changed = true
		elif prev_state > BUTTON_STATE_RELEASED:
			if !action_triggered:
				buttons_diff.set(index, BUTTON_STATE_RELEASED)
				has_button_changed = true
			elif prev_state == BUTTON_STATE_JUST_PRESSED:
				buttons_diff.set(index, BUTTON_STATE_HELD)
				has_button_changed = true

	if has_button_changed:
		diff.set("buttons", buttons_diff)
		has_changed = true

	if enable_lookup_direction:
		var lookup_direction: Vector2 = Input.get_vector(lookup_direction_actions[0], lookup_direction_actions[1], lookup_direction_actions[2], lookup_direction_actions[3])
		if lookup_direction != controller_input.lookup_direction:
			diff.set("lookup_direction", lookup_direction)
			has_changed = true

	if enable_digital_direction:
		var digital_direction: Vector2 = Input.get_vector(digital_direction_actions[0], digital_direction_actions[1], digital_direction_actions[2], digital_direction_actions[3])
		if digital_direction != controller_input.digital_direction:
			diff.set("digital_direction", digital_direction)
			has_changed = true

	if enable_forces:
		var force_left: float = Input.get_action_strength(force_actions[0])
		if force_left != controller_input.force_left:
			controller_input.force_left = force_left
			diff.set("force_left", force_left)
			has_changed = true
		var force_right: float = Input.get_action_strength(force_actions[1])
		if force_right != controller_input.force_right:
			controller_input.force_right = force_right
			diff.set("force_right", force_right)
			has_changed = true

	if Input.is_action_just_pressed(menu_button_actions[1]):
		controller_input.in_menu = !controller_input.in_menu
		diff.set("in_menu", controller_input.in_menu)
		has_changed = true
		toggle_menu.emit(controller_input.in_menu)

	if has_changed:
		ControllerInput.update_from_diff(controller_input, diff)
		controller_input_changed.emit(controller_input)
		ApplicationManager.system_log("inpute changed diff: %s" % [diff])
