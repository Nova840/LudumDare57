extends Node
class_name Sound


const MAX_DISTANCE: float = 500


func _ready() -> void:
	if (self as Variant) is AudioStreamPlayer2D:
		self.max_distance = MAX_DISTANCE
	(self as Variant).play()
	await get_tree().create_timer(10).timeout
	queue_free()
