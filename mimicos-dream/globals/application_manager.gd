extends Node

var log_level: int = 0

var random_generator = RandomNumberGenerator.new()
var runtime_args: RuntimeArgs = RuntimeArgs.new()
var session_name: String = "main":
	set(value):
		session_name = value
		get_window().title = session_name
		
var is_application_focused: bool = true


signal application_focuse_changed(is_focued: bool)

func _ready() -> void:
	var arguments: Dictionary[String, String] = {}
	for argument in OS.get_cmdline_args():
		if argument.contains("="):
			var key_value = argument.split("=")
			arguments[key_value[0].trim_prefix("--")] = key_value[1]
		else:
			# Options without an argument will be present in the dictionary,
			# with the value set to an empty string.
			arguments[argument.trim_prefix("--")] = ""
	_set_argument(arguments)

func _set_argument(arguments: Dictionary[String, String]) -> void:
	for argument in arguments:
		match(argument):
				"host_enet":
					runtime_args.host_enet = true
				"join_enet":
					runtime_args.join_enet = true

func _notification(what: int) -> void:
	#system_log("Mimico application notification", what)
	match(what):
		NOTIFICATION_APPLICATION_FOCUS_IN:
			system_log("Mimico application in forground")
			is_application_focused = true
			application_focuse_changed.emit(true)
		NOTIFICATION_APPLICATION_FOCUS_OUT:
			system_log("Mimico application in background")
			is_application_focused = false
			application_focuse_changed.emit(false)
		NOTIFICATION_WM_CLOSE_REQUEST:
			system_log("Mimico closed")
			get_tree().quit()


func debug(...args: Array) -> void:
	if log_level > 0:
		return
	print_debug("[%s]" % [session_name], args)
	
func debug_only(...args: Array) -> void:
	if log_level == 0:
		print_debug("[%s]" % [session_name], args)

func system_log(...args: Array) -> void:
	if log_level > 1:
		return
	print_debug("[%s]" % [session_name], args)
	
func log(...args: Array) -> void:
	if log_level > 2:
		return
	print_debug("[%s]" % [session_name], args)
	
func warn(...args: Array) -> void:
	if log_level > 3:
		return
	push_warning("[%s]" % [session_name], args)
