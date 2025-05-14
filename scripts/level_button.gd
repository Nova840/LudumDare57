extends Button
class_name LevelButton


@export var drawer_open_sound: PackedScene

@export_file var level_path: String

@onready var start: Start = get_tree().current_scene


func _on_pressed() -> void:
	if start.loading_level: return
	start.set_loading_level()
	var sound := drawer_open_sound.instantiate()
	add_child(sound)
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file(level_path)
