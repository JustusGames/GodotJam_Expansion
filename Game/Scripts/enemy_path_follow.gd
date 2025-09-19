extends PathFollow3D

@onready var Squadron:Node3D = get_node("%Squadron1")

@export var Attack_Start_Ratio:float = 0.0
@export var Attack_End_Ratio:float = 0.0

var _started_bombing:bool = false
var _ended_bombing:bool = false

func _process(delta: float) -> void:
	progress_ratio += .025 * delta
	
	if progress_ratio >= Attack_Start_Ratio and progress_ratio <= Attack_End_Ratio:
		if  !_started_bombing:
			Squadron.start_bombing_run()
			_started_bombing = true
	else:
		if !_ended_bombing and _started_bombing:
			Squadron.end_bombing_run()
			_ended_bombing = true
		#
	if progress_ratio >= .99:
		queue_free()
