extends Node2D
class_name BounceSoundPlayer


static var recent_sounds_played_times: Array[float] = []
const NUM_SOUNDS: int = 5
const NUM_SOUNDS_TIME: float = .5

@export var bounce_sound_scene: PackedScene
@export var bounce_sound_speed_threshold: float = 200
@export var bounce_sound_cooldown: float = .2

@onready var rb: RigidBody2D = $".."

var time_last_sound_played: float = -INF


func _ready() -> void:
	rb.body_entered.connect(_body_entered)


func _body_entered(body: Node2D) -> void:
	var other_velocity: Vector2 = body.linear_velocity if body is RigidBody2D else Vector2.ZERO
	var relative_velocity: Vector2 = get_parent().linear_velocity - other_velocity

	if relative_velocity.length() >= bounce_sound_speed_threshold and \
			time_last_sound_played + bounce_sound_cooldown * 1000 <= Time.get_ticks_msec() and \
			num_sounds_playing() < NUM_SOUNDS and \
			Camera.instance.audio_listener.global_position.distance_to(global_position) <= Sound.MAX_DISTANCE and \
			not (body is RigidBody2D and body.collision_layer & (1 << 1)):
		var sound := bounce_sound_scene.instantiate()
		if sound is AudioStreamPlayer2D:
			sound.top_level = true
			sound.global_position = global_position
		add_child(sound)
		time_last_sound_played = Time.get_ticks_msec()
		recent_sounds_played_times.append(Time.get_ticks_msec())
		if recent_sounds_played_times.size() > NUM_SOUNDS:
			recent_sounds_played_times.remove_at(0)


static func num_sounds_playing() -> int:
	var sounds := recent_sounds_played_times.size()
	for time in recent_sounds_played_times:
		if time >= Time.get_ticks_msec() - NUM_SOUNDS_TIME * 1000:
			return sounds
		sounds -= 1
	return sounds
