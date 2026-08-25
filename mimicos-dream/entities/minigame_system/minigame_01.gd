extends Control

@export var minigame_system: MinigameSystem

@export_category("Internal")
@export var number_buttons: Array[Button] = []
@export var code_state_label: Label

var current_code: String = ""
var needed_code: String = ""

func _ready() -> void:
	for button in number_buttons:
		button.pressed.connect(
			func () -> void:
				_on_number_press(button)
		)
	
func on_activate() -> void:
	if typeof(minigame_system.minigame_data) != TYPE_STRING:
		ApplicationManager.warn("please set right code before starting number buttons")
		_on_button_pressed()
		return
	current_code = ""
	code_state_label.text = ""
	needed_code = minigame_system.minigame_data
	self.show()
	
func on_deactivate() -> void:
	self.hide()
	
func _on_number_press(button: Button) -> void:
	current_code += button.text

func on_success() -> void:
	code_state_label.text = "OK"
	await get_tree().create_timer(0.2).timeout
	minigame_system.minigame_succeed = true
	minigame_system.close_minigame()

func on_fail() -> void:
	current_code = ""
	code_state_label.text = "Error"

func _on_button_pressed() -> void:
	minigame_system.minigame_succeed = false
	minigame_system.close_minigame()

func _on_ok_button_pressed() -> void:
	if current_code == needed_code:
		on_success()
	else:
		on_fail()
