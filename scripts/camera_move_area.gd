extends Area2D
class_name CameraMoveArea


func _on_body_entered(body: Node2D) -> void:
	if body is Hand:
		Camera.instance.can_move = true
