extends Button
class_name LevelButton


@export var drawer_open_sound: PackedScene

@export_file var level_path: String


func _on_pressed() -> void:
	var sound := drawer_open_sound.instantiate()
	add_child(sound)
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file(level_path)
