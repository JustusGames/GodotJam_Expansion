extends Node3D
class_name StandardTurret

@export var FirePointLocatons:Array[Marker3D]
@onready var FireRateTimer:Timer = get_node("%FireRateTimer")
var _allow_firing:bool = true
var _firing_cooldown:float = 1

func fire(pBullet:PackedScene) -> void:
	for firepoint in FirePointLocatons:
		var _bullet_dupe:CharacterBody3D = pBullet.instantiate()	
		_bullet_dupe.global_transform = firepoint.global_transform
		get_tree().root.add_child(_bullet_dupe)




		
