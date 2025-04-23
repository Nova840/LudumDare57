extends Area2D
class_name CameraMoveArea


@export var fade_out_sprite: Sprite2D


func _on_body_entered(body: Node2D) -> void:
	if body is not Hand: return
	Camera.instance.can_move = true
	var fade_percent := 1.0
	while fade_percent > 0:
		await get_tree().process_frame
		fade_out_sprite.modulate.a -= get_process_delta_time()
