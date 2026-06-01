extends Area2D


@export var hand: Hand
@export_range(1, 20500) var top_low_pass_cutoff_hz: float = 20500
@export_range(1, 20500) var bottom_low_pass_cutoff_hz: float = 20500
@export var low_pass_curve: Curve

@onready var low_pass_shape: CollisionShape2D = $Shape


func _process(delta: float) -> void:
	var low_pass_filter: AudioEffectLowPassFilter = AudioServer.get_bus_effect(AudioServer.get_bus_index("Music Bus"), 0)
	var highest_lowest: Array[float] = get_highest_lowest_y(low_pass_shape)
	low_pass_filter.cutoff_hz = lerpf(
		top_low_pass_cutoff_hz,
		bottom_low_pass_cutoff_hz,
		clamp(low_pass_curve.sample(inverse_lerp(highest_lowest[0], highest_lowest[1], hand.global_position.y)), 0, 1)
	)


func get_highest_lowest_y(collision_shape: CollisionShape2D) -> Array[float]:
	var shape := collision_shape.shape as RectangleShape2D
	if shape == null:
		return []

	var half_size := shape.size * 0.5

	var corners: Array[Vector2] = [
		Vector2(-half_size.x, -half_size.y),
		Vector2( half_size.x, -half_size.y),
		Vector2( half_size.x,  half_size.y),
		Vector2(-half_size.x,  half_size.y)
	]

	var highest := collision_shape.global_transform * corners[0]
	var lowest := highest

	for corner in corners:
		var world_point := collision_shape.global_transform * corner

		if world_point.y < highest.y:
			highest = world_point

		if world_point.y > lowest.y:
			lowest = world_point

	return [highest.y, lowest.y]
