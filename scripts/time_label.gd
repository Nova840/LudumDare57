extends Label
class_name TimeLabel


var original_text: String


func _ready() -> void:
	original_text = text
	_set_text()


func _process(delta: float) -> void:
	_set_text()


func _set_text() -> void:
	var game: Game = get_tree().current_scene as Game
	if not game.game_won:
		text = original_text.replace("%s", str(ceili(game.time_left() / 1000)))
