extends Button
class_name QuitGameButton


@onready var start: Start = get_tree().current_scene


func _on_pressed() -> void:
	if start.loading_level: return
	start.set_loading_level()
	get_tree().quit()
