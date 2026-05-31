extends Area2D
class_name CameraMoveArea


@export var fade_out_sprite: Sprite2D
@export var fade_out_time: float = 1

var fade_started := false


func _on_body_entered(body: Node2D) -> void:
	if body is not Hand: return
	if fade_started: return
	fade_started = true
	Camera.instance.can_move = true
	var fade_percent := 1.0
	while fade_percent > 0:
		fade_percent -= get_process_delta_time() / fade_out_time if fade_out_time > 0 else 0.0
		fade_percent = maxf(0, fade_percent)
		fade_out_sprite.modulate.a = fade_percent
		if fade_percent == 0:
			break
		await get_tree().process_frame
