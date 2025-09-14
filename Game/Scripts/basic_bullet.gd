extends CharacterBody3D

var _speed:float = 80
var _bullet_lifetime:float = 5 #seconds

func _physics_process(delta: float) -> void:
	_bullet_lifetime -= delta
	velocity = global_transform.basis.z * -_speed
	var _col = move_and_collide(velocity * delta)	
	if _col:
		queue_free()
	
	if _bullet_lifetime <=0.0:
		queue_free()
