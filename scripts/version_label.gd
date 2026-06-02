extends Label
class_name VersionLabel

func _ready() -> void:
	text = "v" + ProjectSettings.get_setting("application/config/version")
