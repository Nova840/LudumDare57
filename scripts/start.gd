extends Node
class_name Start


static var web_audio_enabled := false

@export var drawer_touch_sound: PackedScene

var loading_level: bool


func _input(event: InputEvent):
	if web_audio_enabled: return
	if event is not InputEventMouseButton: return
	var event_mb: InputEventMouseButton = event
	if event_mb.is_pressed() and event_mb.button_index in [MOUSE_BUTTON_LEFT, MOUSE_BUTTON_RIGHT]:
		web_audio_enabled = true


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	loading_level = false
	MusicAutoload.set_music_just_synth()


func set_loading_level() -> void:
	loading_level = true


func _on_button_mouse_entered() -> void:
	if loading_level: return
	if OS.has_feature("web") and not web_audio_enabled: return
	var sound := drawer_touch_sound.instantiate()
	add_child(sound)
