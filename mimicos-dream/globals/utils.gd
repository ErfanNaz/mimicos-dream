extends Node

func to_dictionary(object: Object, props: Array[String]) -> Dictionary:
	var dic_object = {}
	for prop in props:
		dic_object[prop] = object[prop]
	return dic_object
