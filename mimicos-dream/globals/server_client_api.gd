extends Node

enum Role { CLIENT, SERVER }
var role: Role = Role.SERVER

signal on_role_changed(role: Role)

signal on_server_incomming_command(data: Dictionary)
signal on_command_from_server(data: Dictionary)

func set_role(new_role: Role) -> void:
	if new_role == role:
		return
	role = new_role
	on_role_changed.emit(role)

func is_server() -> bool:
	return role == Role.SERVER

@rpc("any_peer", "call_local")
func server_command(data: Dictionary) -> void:
	if role == Role.SERVER:
		var sender_id = multiplayer.get_remote_sender_id()
		ApplicationManager.system_log("Server hat Aktion erhalten:", sender_id, data)
		data.sender_id = sender_id
		on_server_incomming_command.emit(data)
		
@rpc("any_peer", "call_local")
func broadcast_command(data) -> void:
	ApplicationManager.system_log("broadcast_command Client hat Aktion erhalten:", multiplayer.get_unique_id(), data)
	on_command_from_server.emit(data)

@rpc("authority", "call_local")
func client_command(data) -> void:
	ApplicationManager.system_log("client_command Client hat Aktion erhalten:", multiplayer.get_unique_id(), data)
	on_command_from_server.emit(data)

func send_command_to_server(data: Dictionary) -> void:
	server_command.rpc_id(1, data)  # An Server senden

func send_command_to_clients(data: Dictionary) -> void:
	if role == Role.SERVER:
		client_command.rpc(data)
	
func send_command_to_client(player_id: int, data: Dictionary) -> void:
	broadcast_command.rpc_id(player_id, data)

func send_command_to_all_clients(data: Dictionary):
	broadcast_command.rpc(data)
