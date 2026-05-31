extends Node
class_name Music


@export var volume_change_time: float = 1

@onready var audio_stream_player_cello: AudioStreamPlayer = $AudioStreamPlayerCello
@onready var audio_stream_player_melody: AudioStreamPlayer = $AudioStreamPlayerMelody
@onready var audio_stream_player_percussion: AudioStreamPlayer = $AudioStreamPlayerPercussion

var target_other_volume: float = 0


func _ready() -> void:
	set_volume(target_other_volume)


func _process(delta: float) -> void:
	if volume_change_time <= 0:
		set_volume(target_other_volume)
	else:
		set_volume(move_toward(audio_stream_player_cello.volume_linear, target_other_volume, delta / volume_change_time))


func set_music_just_synth(just_synth: bool) -> void:
	target_other_volume = 0 if just_synth else 1


func set_volume(volume: float) -> void:
	audio_stream_player_cello.volume_linear = volume
	audio_stream_player_melody.volume_linear = volume
	audio_stream_player_percussion.volume_linear = volume
