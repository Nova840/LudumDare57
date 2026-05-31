extends Node
class_name Start


@export var drawer_touch_sound: PackedScene

var loading_level: bool


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	loading_level = false
	MusicAutoload.set_music_just_synth(true)


func set_loading_level() -> void:
	loading_level = true


func _on_button_mouse_entered() -> void:
	if loading_level: return
	var sound := drawer_touch_sound.instantiate()
	add_child(sound)
