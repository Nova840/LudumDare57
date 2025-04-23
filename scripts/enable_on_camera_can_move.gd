extends CollisionShape2D
class_name EnableOnCameraaCanMove


func _ready() -> void:
	disabled = true
	Camera.instance.camera_can_move_change.connect(func(can_move: bool): disabled = false)
