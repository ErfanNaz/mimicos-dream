class_name PlayerInteractable extends Node3D

@export var player_controller: PlayerController
@export var player_interactable: Interaction

var registered_interactable_actions: Dictionary[int, Interaction] = {}

signal registered_actions_changed(action_map: Dictionary[int, Interaction], diff: Interaction)
signal on_player_hunted(hunter: PlayerController, prey: PlayerController)

var is_hunting: bool = false
var is_enabled: bool = false

func _ready() -> void:
	enable()

func reset() -> void:
	registered_interactable_actions = {}

func enable() -> void:
	if is_enabled:
		return
	is_enabled = true
	player_interactable.on_entity_entered.connect(self._on_entity_entered)
	player_interactable.on_entity_exited.connect(self._on_entity_exited)
	var entitie_list: Array[Interaction] = player_interactable.get_overlapping_entities()
	for _interaction in entitie_list:
		_on_entity_entered(_interaction)
	
func disable() -> void:
	if !is_enabled:
		return
	is_enabled = false
	player_interactable.on_entity_entered.disconnect(self._on_entity_entered)
	player_interactable.on_entity_exited.disconnect(self._on_entity_exited)

func enable_hunting() -> void:
	if is_hunting:
		return
	is_hunting = true
	player_interactable.monitorable = false
	player_interactable.on_player_entered.connect(self._on_player_entered)
	var player_list: Array[Interaction] = player_interactable.get_overlapping_players()
	disable()
	for _interaction in player_list:
		_on_player_entered(_interaction)

func disable_hunting() -> void:
	if !is_hunting:
		return
	is_hunting = false
	enable()
	player_interactable.monitorable = true
	player_interactable.on_player_entered.disconnect(self._on_player_entered)

func _on_entity_entered(interaction: Interaction) -> void:
	var interact_data: InteractData = interaction.interact_data
	ApplicationManager.system_log("Player:%d connected with:%s" % [player_controller.id, interact_data.title])
	if interact_data.action_button == -1:
		interaction.on_interact.emit(player_controller)
		return
	if registered_interactable_actions.has(interaction):
		ApplicationManager.warn("Player:%d is already in list:%s" % [player_controller.id, interaction])
		return
	registered_interactable_actions.set(interact_data.action_button, interaction)

func _on_entity_exited(interaction: Interaction) -> void:
	var interact_data: InteractData = interaction.interact_data
	ApplicationManager.system_log("Player:%d disconnected with:%s" % [player_controller.id, interact_data.title])
	var current_interaction: Interaction = registered_interactable_actions.get(interact_data.action_button, null)
	if current_interaction == null || current_interaction != interaction:
		return
	registered_interactable_actions.erase(interact_data.action_button)
	registered_actions_changed.emit(registered_interactable_actions, interaction)

func _on_player_entered(interaction: Interaction) -> void:
	var interact_data: InteractData = interaction.interact_data
	ApplicationManager.system_log("Player:%d try to hunt with:%s" % [player_controller.id, interact_data.title])
	var _player_controller: PlayerController = GameManager.player_controllers.get(interact_data.title, null)
	if _player_controller == null:
		ApplicationManager.warn("can not find player with name:%s" % [interact_data.title])
		return
	if _player_controller.is_knockbacked:
		return
	on_player_hunted.emit(player_controller, _player_controller)
