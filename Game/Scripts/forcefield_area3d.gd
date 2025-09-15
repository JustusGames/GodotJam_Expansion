extends Area3D

@onready var _forcfield_mesh:CSGSphere3D = get_node("%Forcfield")
var offset_x:float = 0


func _process(delta: float) -> void:
	offset_x += .01 * delta
	_forcfield_mesh.material.set("uv1_offset",Vector3(offset_x,-offset_x,0))
