extends Control


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
	
