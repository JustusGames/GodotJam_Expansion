extends Control

@onready var _healthbar:ProgressBar = get_node("%HealthBar")
@onready var _energybar:ProgressBar = get_node("%EnergyBar")
@onready var _ammo_count:Label = get_node("%AmmoLabel")
@onready var _ammo_reload_label:Label = get_node("%AmmoReloadLabel")

@export var _building_pop_scene:PackedScene
var _current_pop_up:Control = null

signal building_placed(pBuilding:String)

func show_menu_at_mouse(pEvent) -> void:
	if is_instance_valid(_current_pop_up):
		if _current_pop_up.is_connected("popup_building_selected",_on_popup_building_selected):
			_current_pop_up.disconnect("popup_building_selected",_on_popup_building_selected)
		_current_pop_up.queue_free()
	if !is_instance_valid(_current_pop_up):
		_current_pop_up = _building_pop_scene.instantiate()
		self.add_child(_current_pop_up)
		if !_current_pop_up.is_connected("popup_building_selected",_on_popup_building_selected):
			_current_pop_up.connect("popup_building_selected",_on_popup_building_selected)
		_current_pop_up.position = pEvent.position - _current_pop_up.size / 2

func _on_popup_building_selected(pBuilding:String):
	emit_signal("building_placed",pBuilding)

func remove_menus():
	if is_instance_valid(_current_pop_up):
		if _current_pop_up.is_connected("popup_building_selected",_on_popup_building_selected):
			_current_pop_up.disconnect("popup_building_selected",_on_popup_building_selected)
		_current_pop_up.queue_free()
	
func update_energy(pAmount:float):
	_energybar.value = pAmount

func update_health(pAmount:float):
	_healthbar.value = pAmount

func update_ammo(pAmount:int):
	_ammo_count.text = str(pAmount)

func show_ammmo_reload_amount(pAmount:int):
	_ammo_reload_label.text = "+" + str(pAmount)
	_ammo_reload_label.modulate = Color(1.0, 1.0, 1.0)
	await  get_tree().create_timer(1).timeout
	_ammo_reload_label.modulate = Color(0.027, 0.043, 0.145)
