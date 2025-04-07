extends Area2D
class_name PlacementArea


var batteries_inside: int = 0
var game_won: bool = false


func _on_body_entered(body: Node2D) -> void:
	if body.get_meta("battery", false):
		batteries_inside += 1
		if not game_won and batteries_inside >= (get_tree().current_scene as Game).batteries_to_win:
			game_won = true
			print("foop")


func _on_body_exited(body: Node2D) -> void:
	if body.get_meta("battery", false):
		batteries_inside -= 1
