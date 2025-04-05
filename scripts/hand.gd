extends Node2D
class_name Hand


func _process(delta: float) -> void:
	global_position = get_global_mouse_position()
