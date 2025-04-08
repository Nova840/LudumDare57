extends Node
class_name BounceSoundPlayer


@export var bounce_sound_scene: PackedScene

@onready var rb: RigidBody2D = $".."


func _ready() -> void:
	rb.body_entered.connect(_body_entered)


func _body_entered(body: Node2D) -> void:
	print("ASDH")
	var sound := bounce_sound_scene.instantiate()
	add_child(sound)
