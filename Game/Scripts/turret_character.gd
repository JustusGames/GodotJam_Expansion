extends CharacterBody3D

#@onready var _main_camera:Camera3D = get_node("%Camera3D")
@onready var _turret:StandardTurret = get_node("%StandardTurret")
@export var _basic_bullet:PackedScene
var _mouse_sensitivity = .002
var _camera_rotation:Vector2 = Vector2(0,0)
var _allow_firing:bool = true
var _firing_cooldown:float = 0.0
var Fire_Rate:float = 5

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _process(delta: float) -> void:
	if Input.is_action_pressed("Primary Fire") and _allow_firing:
		if is_instance_valid(_turret):
			_turret.fire(_basic_bullet)
			_allow_firing = false
			_firing_cooldown = 1.0 / Fire_Rate
	
	if !_allow_firing:
		_firing_cooldown -= delta
		if _firing_cooldown <= 0.0:
			_allow_firing = true
		

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		var MouseEvent = event.relative * _mouse_sensitivity
		CameraLook(MouseEvent)
	#
	#if event.is_action_pressed("Primary Fire"):
		#if is_instance_valid(_turret):
			#_turret.fire(_basic_bullet)

func CameraLook(Movement: Vector2):
	_camera_rotation += Movement
	transform.basis = Basis()	
	rotate_object_local(Vector3(0,1,0),-_camera_rotation.x)
	rotate_object_local(Vector3(1,0,0), -_camera_rotation.y)
	_camera_rotation.y = clamp(_camera_rotation.y,-1.5,1.2)
