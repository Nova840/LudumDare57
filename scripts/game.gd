extends Node
class_name Game


@export var win_image: PackedScene
@export var lose_image: PackedScene

@export var batteries_to_win: int = 1
@export var game_time: float = 60
@export var end_game_delay_before_return: float = 5

var time_game_started: float
var batteries_retrieved: int = 0
var game_won: bool = false
var game_lost: bool = false


func _enter_tree() -> void:
	time_game_started = Time.get_ticks_msec()


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Escape"):
		get_tree().change_scene_to_file("res://scenes/start.tscn")

	if not game_lost and not game_won and time_left() <= 0:
		game_lost = true
		var lose_scene := lose_image.instantiate()
		add_child(lose_scene)
		load_start_after_delay()


func win() -> void:
	if game_won or game_lost or time_left() <= 0: return

	game_won = true
	var win_scene := win_image.instantiate()
	add_child(win_scene)
	load_start_after_delay()


func time_left() -> float:
	return max(0, time_game_started + game_time * 1000 - Time.get_ticks_msec())


func load_start_after_delay() -> void:
	await get_tree().create_timer(end_game_delay_before_return).timeout
	get_tree().change_scene_to_file("res://scenes/start.tscn")
