extends AudioStreamPlayer
class_name GrabSound


@export var sounds: Array[AudioStream]

@onready var random := RandomNumberGenerator.new()


func _ready() -> void:
	stream = sounds[random.randi_range(0, sounds.size() - 1)]
	play()
	await get_tree().create_timer(10).timeout
