extends Node

func to_dictionary(object: Object, props: Array[String]) -> Dictionary:
	var dic_object = {}
	for prop in props:
		dic_object[prop] = object[prop]
	return dic_object

func find_animation_player_in_glb(node: Node) -> AnimationPlayer:
	for child in node.get_children():
		if child is AnimationPlayer:
			return child
	return null
