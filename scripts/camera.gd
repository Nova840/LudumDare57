extends Camera2D
class_name Camera


@export var follow: Node2D

@export var follow_speed: float
@export var follow_max_speed: float
@export var move_deadzone: float


func _process(delta: float) -> void:
	var screen_middle_position := get_canvas_transform().affine_inverse() * (get_tree().root.size as Vector2 / 2)
	var speed_multiplier := clampf((screen_middle_position.distance_to(follow.global_position) - move_deadzone) / 100, 0, 1)
	var target_global_position := global_position.lerp(follow.global_position, follow_speed * speed_multiplier * delta)
	global_position = global_position.move_toward(target_global_position, follow_max_speed * delta)
