extends Area2D
class_name PlacementArea



var game_won: bool = false


func _on_body_entered(body: Node2D) -> void:
	if body.get_meta("battery", false):
		var game: Game = get_tree().current_scene
		game.batteries_retrieved += 1
		if not game_won and game.batteries_retrieved >= game.batteries_to_win:
			game_won = true
			game.win()


func _on_body_exited(body: Node2D) -> void:
	if body.get_meta("battery", false):
		var game: Game = get_tree().current_scene
		game.batteries_retrieved -= 1
