class_name Interaction extends Area3D

const DEFAULT_LAYER: int = 16

signal on_entity_entered(interaction: Interaction)
signal on_entity_exited(interaction: Interaction)
signal on_player_entered(interaction: Interaction)
signal on_player_exited(interaction: Interaction)
signal on_area_entered(area: Area3D)
signal on_area_exited(area: Area3D)

signal on_interact(player_controller: PlayerController)

@export var interact_data: InteractData

@export_range(1, 32, 1, "prefer_slider") var interaction_layer: int = DEFAULT_LAYER:
	set(value):
		if value == interaction_layer:
			return
		self.set_collision_layer_value(interaction_layer, false)
		self.set_collision_mask_value(interaction_layer, false)
		interaction_layer = value
		self.set_collision_layer_value(interaction_layer, true)
		self.set_collision_mask_value(interaction_layer, true)

var default_data: InteractData = InteractData.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if !interact_data:
		interact_data = default_data
	else:
		interact_data = interact_data.duplicate()
	if interaction_layer == DEFAULT_LAYER:
		self.set_collision_layer_value(1, false)
		self.set_collision_mask_value(1, false)
		self.set_collision_layer_value(DEFAULT_LAYER, true)
		self.set_collision_mask_value(DEFAULT_LAYER, true)
	self.area_exited.connect(self._on_area_exited)
	self.area_entered.connect(self._on_area_entered)
	

func activate() -> void:
	self.set_deferred("monitorable", true)
	self.set_deferred("monitoring", true)

func deactivate() -> void:
	self.set_deferred("monitorable", false)
	self.set_deferred("monitoring", false)

func get_overlapping_players() -> Array[Interaction]:
	var overlapping_players: Array[Interaction] = []
	for area in get_overlapping_areas():
		if area is not Interaction:
			continue
		var interaction: Interaction = area
		var data: InteractData = interaction.interact_data 
		if !data:
			ApplicationManager.warn("missing interaction data %s" % [interaction.name], interaction)
			continue
		if data.type != InteractData.InteractableType.player:
			continue
		overlapping_players.append(interaction)
	return overlapping_players

func get_overlapping_entities() -> Array[Interaction]:
	var overlapping_entities: Array[Interaction] = []
	for area in get_overlapping_areas():
		if area is not Interaction:
			continue
		var interaction: Interaction = area
		var data: InteractData = interaction.interact_data 
		if !data:
			ApplicationManager.warn("missing interaction data %s" % [interaction.name], interaction)
			continue
		if data.type != InteractData.InteractableType.entity:
			continue
		overlapping_entities.append(interaction)
	return overlapping_entities


func _on_area_entered(area: Area3D) -> void:
	if area is Interaction:
		var interaction: Interaction = area
		var data: InteractData = interaction.interact_data 
		if !data:
			ApplicationManager.warn("missing interaction data %s" % [interaction.name], interaction)
			return
		if data.type == InteractData.InteractableType.entity:
			on_entity_entered.emit(interaction)
		else:
			on_player_entered.emit(interaction)
	else:
		on_area_entered.emit(area)

func _on_area_exited(area: Area3D) -> void:
	if area is Interaction:
		var interaction: Interaction = area
		var data: InteractData = interaction.interact_data
		if !data:
			ApplicationManager.warn("missing interaction data %s" % [interaction.name], interaction)
			return
		if data.type == InteractData.InteractableType.entity:
			on_entity_exited.emit(interaction)
		else:
			on_player_exited.emit(interaction)
	else:
		on_area_exited.emit(area)
