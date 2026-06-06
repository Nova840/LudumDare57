extends Button
class_name QuitGameButton


@export var drawer_close_sound: PackedScene
@export var delay: float = 0

@onready var start: Start = get_tree().current_scene


func _ready() -> void:
	if OS.has_feature("web"):
		queue_free()


func _on_pressed() -> void:
	if start.loading_level: return
	var sound := drawer_close_sound.instantiate()
	add_child(sound)
	start.set_loading_level()
	await get_tree().create_timer(delay).timeout
	get_tree().quit()
