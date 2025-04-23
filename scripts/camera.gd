extends Camera2D
class_name Camera


signal camera_can_move_change(can_move: bool)

static var instance: Camera

@export var follow: Node2D

@export var follow_speed: float
@export var follow_max_speed: float
@export var move_deadzone: float

@onready var audio_listener: AudioListener2D = $AudioListener2D

var can_move = false:
	set(value):
		can_move = value
		camera_can_move_change.emit(can_move)


func _ready() -> void:
	instance = self


func _physics_process(delta: float) -> void:
	if not can_move: return
	var screen_middle_position := get_screen_center_position()
	var speed_multiplier := clampf((screen_middle_position.distance_to(follow.global_position) - move_deadzone) / 100, 0, 1)
	var target_global_position := global_position.lerp(follow.global_position, clampf(follow_speed * speed_multiplier * delta, 0, 1))
	global_position = global_position.move_toward(target_global_position, follow_max_speed * delta)
