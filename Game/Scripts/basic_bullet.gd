extends CharacterBody3D

var _speed:float = 80
var _bullet_lifetime:float = 5 #seconds
@export var _impact_particles:PackedScene

func _physics_process(delta: float) -> void:
	_bullet_lifetime -= delta
	velocity = global_transform.basis.z * -_speed
	var _col = move_and_collide(velocity * delta)	
	if _col:
		var _new_impact_fx:GPUParticles3D = _impact_particles.instantiate()
		get_tree().root.add_child(_new_impact_fx)
		_new_impact_fx.global_position = _col.get_position()

		if _col.get_collider().has_method("Hit_Registered"):
			_col.get_collider().Hit_Registered()		
		queue_free()
	
	if _bullet_lifetime <=0.0:
		queue_free()
