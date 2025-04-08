extends Label
class_name InstructionLabel


var original_text: String


func _ready() -> void:
	original_text = text
	_set_text()


func _process(delta: float) -> void:
	_set_text()


func _set_text() -> void:
	var game: Game = get_tree().current_scene as Game
	var batteries_left: int = game.batteries_to_win - game.batteries_retrieved if not game.game_won else 0
	text = original_text.replace("%s", str(batteries_left))
