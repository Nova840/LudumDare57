extends Node
class_name Music


@export var volume_change_time: float = 2

@onready var audio_stream_player_cello: AudioStreamPlayer = $AudioStreamPlayerCello
@onready var audio_stream_player_synth: AudioStreamPlayer = $AudioStreamPlayerSynth
@onready var audio_stream_player_melody: AudioStreamPlayer = $AudioStreamPlayerMelody
@onready var audio_stream_player_percussion: AudioStreamPlayer = $AudioStreamPlayerPercussion

var target_volume_cello_linear: float = 0
var target_volume_synth_linear: float = 1
var target_volume_melody_linear: float = 0
var target_volume_percussion_linear: float = 0


func _ready() -> void:
	_set_volume_to_target()


func _process(delta: float) -> void:
	if volume_change_time <= 0:
		_set_volume_to_target()
	else:
		_set_volume_linear(
			move_toward(audio_stream_player_cello.volume_linear, target_volume_cello_linear, delta / volume_change_time),
			move_toward(audio_stream_player_synth.volume_linear, target_volume_synth_linear, delta / volume_change_time),
			move_toward(audio_stream_player_melody.volume_linear, target_volume_melody_linear, delta / volume_change_time),
			move_toward(audio_stream_player_percussion.volume_linear, target_volume_percussion_linear, delta / volume_change_time),
		)


func set_music_just_synth() -> void:
	set_target_volume_linear(0, 1, 0, 0)


func _set_volume_to_target() -> void:
	_set_volume_linear(
		target_volume_cello_linear,
		target_volume_synth_linear,
		target_volume_melody_linear,
		target_volume_percussion_linear
	)


func _set_volume_linear(cello_vol: float, synth_vol: float, melody_vol: float, percussion_vol: float) -> void:
	audio_stream_player_cello.volume_linear = cello_vol
	audio_stream_player_synth.volume_linear = synth_vol
	audio_stream_player_melody.volume_linear = melody_vol
	audio_stream_player_percussion.volume_linear = percussion_vol


func set_target_volume_linear(cello_vol: float, synth_vol: float, melody_vol: float, percussion_vol: float) -> void:
	target_volume_cello_linear = cello_vol
	target_volume_synth_linear = synth_vol
	target_volume_melody_linear = melody_vol
	target_volume_percussion_linear = percussion_vol
