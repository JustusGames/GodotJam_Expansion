extends CharacterBody3D

@onready var _main_camera:Camera3D = get_node("%Camera3D")
@export var _building_camera:Camera3D
@onready var _turret:StandardTurret = get_node("%StandardTurret")
@onready var _HUD:Control = get_node("%HUD")
@export var _basic_bullet:PackedScene
#################
enum turret_states {
	turret_mode,
	building_mode
}
var current_turret_state:int = turret_states.turret_mode
#################
var _mouse_sensitivity = .002
var _camera_rotation:Vector2 = Vector2(0,0)
var _allow_firing:bool = true
var _in_build_mode:bool = false
var _firing_cooldown:float = 0.0
var _looked_at_object:Object = null
var _selected_build_spot:BuildSpot = null
var Fire_Rate:float = 5

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	_HUD.connect("building_placed",_on_building_place)

func _on_building_place(pBuilding:String):
	if is_instance_valid(_selected_build_spot):
		if _selected_build_spot.spot_taken == false:
			_selected_build_spot.spawn_new_building(pBuilding)
			_selected_build_spot = null

func _physics_process(_delta: float) -> void:
	
	match current_turret_state:
		turret_states.building_mode:	
			var space = get_world_3d().direct_space_state
			var mousePosViewport = get_viewport().get_mouse_position()
			var camera = _building_camera
			var rayOrigin = camera.project_ray_origin(mousePosViewport)
			var rayEnd = rayOrigin+camera.project_ray_normal(mousePosViewport)*100
			var detectionParameters = PhysicsRayQueryParameters3D.new() 
			detectionParameters.collide_with_areas = true
			detectionParameters.from = rayOrigin
			detectionParameters.to = rayEnd

			var rayArray = space.intersect_ray(detectionParameters)
			if rayArray:
				_looked_at_object = rayArray["collider"]
			else:
				_looked_at_object = null

func _process(delta: float) -> void:	
	match current_turret_state:
		turret_states.turret_mode:
			_primary_fire_held(delta)
		turret_states.building_mode:
			pass	

func _primary_fire_held(delta):
	if Input.is_action_pressed("Primary Fire") and _allow_firing:
		if is_instance_valid(_turret):
			_turret.fire(_basic_bullet)
			_main_camera.CameraShake()
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
	
	if event.is_action_released("Left Click"):
		if is_instance_valid(_looked_at_object) and _looked_at_object.name.begins_with("BuildSpot"):
			if _looked_at_object.spot_taken == false:
				_HUD.show_menu_at_mouse(event)
				_selected_build_spot = _looked_at_object
		else:
			_HUD.remove_menus()
			_selected_build_spot = null
	
	if event.is_action_pressed("SwitchCamera"):
		if is_instance_valid(_building_camera):
			match current_turret_state:
				turret_states.turret_mode:
					_building_camera.current = true
					_main_camera.current = false
					Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
					current_turret_state = turret_states.building_mode
				turret_states.building_mode:
					_main_camera.current = true
					_building_camera.current = false
					Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
					current_turret_state = turret_states.turret_mode

func CameraLook(Movement: Vector2):
	if !_in_build_mode:
		_camera_rotation += Movement
		transform.basis = Basis()	
		rotate_object_local(Vector3(0,1,0),-_camera_rotation.x)
		rotate_object_local(Vector3(1,0,0), -_camera_rotation.y)
		_camera_rotation.y = clamp(_camera_rotation.y,-1.5,1.2)
