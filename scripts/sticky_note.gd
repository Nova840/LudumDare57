extends Node
class_name StickyNote


@export var base_colors: Array[Color]
@export var overlay_textures: Array[Texture2D]

@onready var base: Sprite2D = $Base
@onready var overlay: Sprite2D = $Overlay

@onready var random := RandomNumberGenerator.new()


func _ready() -> void:
	base.self_modulate = base_colors[random.randi_range(0, base_colors.size() - 1)]
	overlay.texture = overlay_textures[random.randi_range(0, overlay_textures.size() - 1)]
