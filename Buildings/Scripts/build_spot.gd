extends Area3D
class_name BuildSpot

@onready var highlight_building_root:Node3D = get_node("%BaseSelectedHighlight")


var spot_taken:bool = false

var building_dict:Dictionary = {
	"Power":"res://Buildings/Scenes/power_station.tscn",
	"Ammo":"res://Buildings/Scenes/ammo_station.tscn",
	"Health":"res://Buildings/Scenes/health_station.tscn"
}

func spawn_new_building(pBuilding:String = "") -> void:
	var _load_building:PackedScene = load(building_dict[pBuilding])
	if is_instance_valid(_load_building):
		var _building_inst:Area3D = _load_building.instantiate()
		get_tree().root.add_child(_building_inst)
		_building_inst.global_position = self.global_position
		Global.add_to_targetable_locations(self.global_position)
		spot_taken = true		
		monitorable = false
		monitoring = false


func _on_mouse_entered() -> void:
	if !spot_taken:
		highlight_building_root.visible = true

func _mouse_exit() -> void:
	highlight_building_root.visible = false
