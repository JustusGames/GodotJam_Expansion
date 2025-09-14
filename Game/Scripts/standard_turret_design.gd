extends Node3D
class_name StandardTurret

@export var FirePointLocatons:Array[Marker3D]
@onready var FireRateTimer:Timer = get_node("%FireRateTimer")
@onready var _gun_barrel:Node3D = get_node("%BarrelRoot")

func fire(pBullet:PackedScene) -> void:
	
	var tween = get_tree().create_tween()
	var n = Vector3(0,.879,-1.2)
	tween.tween_property(_gun_barrel,"position",n,.1)
	tween.tween_property(_gun_barrel,"position",Vector3(0,.879,-2.2),.1)
	
	for firepoint in FirePointLocatons:
		var _bullet_dupe:CharacterBody3D = pBullet.instantiate()	
		_bullet_dupe.global_transform = firepoint.global_transform
		get_tree().root.add_child(_bullet_dupe)
