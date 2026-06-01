extends Area2D
class_name MusicArea


@export_range(-80, 6) var cello_db: float = 0
@export_range(-80, 6) var synth_db: float = 0
@export_range(-80, 6) var melody_db: float = 0
@export_range(-80, 6) var percussion_db: float = 0


func _on_body_entered(body: Node2D) -> void:
	if body is not Hand: return
	MusicAutoload.set_target_volume_linear(
		db_to_linear(cello_db),
		db_to_linear(synth_db),
		db_to_linear(melody_db),
		db_to_linear(percussion_db)
	)
