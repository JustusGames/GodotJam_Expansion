extends Node

var targetable_locations_array:Array[Vector3] = []


func add_to_targetable_locations(pLocationToAdd:Vector3 = Vector3(0,0,0)):
	targetable_locations_array.append(pLocationToAdd)
	if targetable_locations_array.size() > 1:
		get_tree().call_group("Enemy","find_target")



func get_targetable_locations() -> Array[Vector3]:
	return targetable_locations_array
