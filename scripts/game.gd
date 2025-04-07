extends Node
class_name Game

@export var batteries_to_win: int = 1
@export var game_time: float = 60

var time_game_started: float
var batteries_retrieved: int = 0

func _enter_tree() -> void:
	time_game_started = Time.get_ticks_msec()


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Escape"):
		get_tree().change_scene_to_file("res://scenes/start.tscn")


func win() -> void:
	print("Game won")


func time_left() -> float:
	return max(0, time_game_started + game_time * 1000 - Time.get_ticks_msec())
