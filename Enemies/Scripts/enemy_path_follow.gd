extends PathFollow3D


@export var Enemy_Speed:float = .025
var _current_enemy_speed:float = .025

var Attack_Start_Ratio:float = 0.0
var Attack_End_Ratio:float = 0.0
var Bomber:bool = false
var Slow_During_Attack:bool = true

var _started_bombing:bool = false
var _ended_bombing:bool = false
var _allow_movement:bool = true

signal reached_path_end

func _process(delta: float) -> void:
	if _allow_movement:
		if get_child_count() >= 1:
			progress_ratio += _current_enemy_speed * delta	
			if progress_ratio >= Attack_Start_Ratio and progress_ratio <= Attack_End_Ratio:
				if  !_started_bombing:
					if Slow_During_Attack:
						_current_enemy_speed = _current_enemy_speed/4
					if !Bomber:
						get_child(0).start_firing()
					if Bomber:
						get_child(0).start_bombing()
					_started_bombing = true
			else:
				if !_ended_bombing and _started_bombing:
					if Slow_During_Attack:
						_current_enemy_speed = Enemy_Speed
					get_child(0).end_all_attacks()
					_ended_bombing = true
		#
		if progress_ratio >= .99:
			emit_signal("reached_path_end")
			_allow_movement = false
