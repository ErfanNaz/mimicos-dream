class_name PlayerControllerCommand extends Resource

enum CommandType {
	catched, # payload { hunter_id: int }
	group_changed, # payload { group: GameMode.GameGroups }
	team_changed, # payload { team: int }
	remove_interactable, # payload { key: int }
	add_interactable, # payload { icon: Texture2D, key: int, interact: (PlayerController) -> void }
	reset,
	possession_change,
	open_minigame, # payload = { key: int, icon: Texture2D, controllers: PlayerController[] }
}

@export var action: CommandType
@export var player_id: int = 0 # 0 = all
@export var payload: Dictionary = {}

static func build_command(_action: PlayerControllerCommand.CommandType, _player_id: int, _payload: Dictionary) -> PlayerControllerCommand:
	var command: PlayerControllerCommand = PlayerControllerCommand.new()
	command.action = _action
	command.payload = _payload
	command.player_id = _player_id
	return command
	
static func create_command_add_interactable(_player_id: int, key: int, icon: Texture2D, interact: Callable) -> PlayerControllerCommand:
	return build_command(PlayerControllerCommand.CommandType.add_interactable, _player_id,
		{ "key" : key, "icon": icon, "interact": interact }
	)
	
static func create_command_reset() -> PlayerControllerCommand:
	return build_command(PlayerControllerCommand.CommandType.reset, 0, {})

static func create_command_open_minigame(_player_id: int, key: int, icon: Texture2D, controllers: Array[PlayerController]) -> PlayerControllerCommand:
	return build_command(PlayerControllerCommand.CommandType.open_minigame, _player_id,
		{ "key" : key, "icon": icon, "controllers": controllers }
	)
	
static func create_command_remove_interactable(_player_id: int, key: int) -> PlayerControllerCommand:
	return build_command(PlayerControllerCommand.CommandType.remove_interactable, _player_id,
		{ "key" : key }
	)

static func create_command_catched(_player_id: int, hunter_id: int) -> PlayerControllerCommand:
	return build_command(PlayerControllerCommand.CommandType.catched, _player_id,
		{ "hunter_id" : hunter_id }
	)

static func create_command_team_changed(_player_id: int, team: int) -> PlayerControllerCommand:
	return build_command(PlayerControllerCommand.CommandType.team_changed, _player_id,
		{ "team" : team }
	)
