extends Node
class_name StickyNote


@export var base_colors: Array[Color]
@export var overlay_textures: Array[Texture2D]
@export_range(0, 1) var chance_of_overlay: float

@onready var base: Sprite2D = $Base
@onready var overlay: Sprite2D = $Overlay


func _ready() -> void:
	base.self_modulate = base_colors[randi_range(0, base_colors.size() - 1)]
	var has_image: bool = randf() < chance_of_overlay
	if has_image:
		overlay.texture = overlay_textures[randi_range(0, overlay_textures.size() - 1)]
