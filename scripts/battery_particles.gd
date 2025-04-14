extends Node2D
class_name BatteryParticles


func _ready() -> void:
	global_position = get_parent().global_position


func _physics_process(delta: float) -> void:
	global_position = get_parent().global_position
