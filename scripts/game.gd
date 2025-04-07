extends Node
class_name Game


@export var batteries_to_win: int = 1


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Escape"):
		get_tree().change_scene_to_file("res://scenes/start.tscn")
