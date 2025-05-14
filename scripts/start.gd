extends Node
class_name Start


var loading_level: bool


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	loading_level = false


func set_loading_level() -> void:
	loading_level = true
