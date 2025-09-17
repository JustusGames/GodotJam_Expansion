extends CharacterBody3D
class_name Enemy

@onready var _enemy_body_root:Node3D = get_node("%Body")
@onready var _enemy_bodyhit_root:Node3D = get_node("%BodyHIT")
@onready var _fire_point:Marker3D = get_node("%FirePoint")
@export var _basic_bullet:PackedScene


@export var Health:float = 8
@export var _explosion_particles:PackedScene

var _hit_shake_period = 0.15
var _hit_shake_magnitude = 0.4
var _look_at_target:bool = false
var _look_at_location:Vector3 = Vector3()
var initial_transform:Transform3D 
var _new_fire_timer:Timer = null

func _physics_process(_delta: float) -> void:

	if _look_at_target:
		look_at(Vector3(_look_at_location))

func _ready() -> void:
	randomize()
	_enemy_bodyhit_root.visible = false
	_enemy_body_root.visible = true
	initial_transform = _enemy_body_root.transform 
	
	
	
	await get_tree().create_timer(4).timeout
	find_target()

func Hit_Registered(_pDamage:float = 1):
	if Health <= 0:
		_destroy()
	else:
		Health -= 1
		_enemy_bodyhit_root.visible = true
		_impact_shake()
		await get_tree().create_timer(.1).timeout
		_enemy_bodyhit_root.visible = false

func _destroy():
	var _new_explosion_fx:GPUParticles3D = _explosion_particles.instantiate()
	get_tree().root.add_child(_new_explosion_fx)
	_new_explosion_fx.global_position = self.global_position
	
	var tween = get_tree().create_tween()
	var n = Vector3(1.2,1.2,1.2)
	tween.tween_property(self,"scale",n,.1)
	tween.tween_callback(queue_free)


func find_target():
	var _targets:Array[Vector3] = Global.get_targetable_locations()

	if _targets.size() >= 1:
		_look_at_target = true
		var _random:int = randi_range(0,_targets.size()-1)
		_look_at_location = _targets[_random]		
		
		if !is_instance_valid(_new_fire_timer):
			_new_fire_timer = Timer.new()
			_new_fire_timer.wait_time = randf_range(1,2)
			_new_fire_timer.connect("timeout",_fire)
			add_child(_new_fire_timer)
			_new_fire_timer.start()

func _impact_shake() -> void:	
	var elapsed_time = 0.0
	while elapsed_time < _hit_shake_period:
		var offset = Vector3(
			randf_range(-_hit_shake_magnitude, _hit_shake_magnitude),
			randf_range(-_hit_shake_magnitude, _hit_shake_magnitude),
			0.0
		)

		_enemy_body_root.transform.origin = initial_transform.origin + offset
		elapsed_time += get_process_delta_time()
		await get_tree().process_frame
	_enemy_body_root.transform = initial_transform

func _fire():
		var _bullet_dupe:CharacterBody3D = _basic_bullet.instantiate()	
		_bullet_dupe.global_transform = _fire_point.global_transform
		get_tree().root.add_child(_bullet_dupe)
