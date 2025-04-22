extends Node
class_name RandomSound


func _ready() -> void:
	(self as Variant).play()
	if is_instance_valid(self.stream):
		await get_tree().create_timer(10).timeout
	queue_free()
