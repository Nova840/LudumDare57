extends Button
class_name LevelButton


@export_file var level_path: String


func _on_pressed() -> void:
	get_tree().change_scene_to_file(level_path)
