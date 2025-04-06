extends Area2D
class_name PlacementArea


func _on_body_entered(body: Node2D) -> void:
	if body.get_meta("red_kitty", false):
		print("foop")
