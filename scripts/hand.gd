extends RigidBody2D
class_name Hand


@export var move_speed: float
@export var max_speed: float
@export var slow_max_speed: float
@export var hit_impulse: float
@export var hit_cooldown: float
@export var rotate_speed: float
@export var rotate_linear_speed_threshold: float
@export var slow_rotate_linear_speed_threshold: float
@export_flags_2d_physics var pick_up_mask: int
@export var create_arm_point_distance: float
@export var ouch_scene: PackedScene
@export var ouch_lifetime: float
@export var min_volume_stretch_db: float = -80
@export var grab_sound_scene: PackedScene
@export var wall_hit_sound_scene: PackedScene
@export var knife_hurt_sound_scene: PackedScene
@export var pin_hurt_sound_scene: PackedScene
@export var glue_hurt_sound_scene: PackedScene

@onready var arm_point: Node2D = $ArmPoint
@onready var arm_line: Line2D = $ArmPoint/ArmLine
@onready var stretch_1: AudioStreamPlayer = $Stretch1
@onready var stretch_2: AudioStreamPlayer = $Stretch2

var holding: RigidBody2D = null
var holding_local_offset: Vector2
var holding_global_rotation_on_pickup: float
var hand_rotation_on_pickup: float
var bodies_able_to_pick_up: Array[RigidBody2D] = []
var time_last_hit: float = -INF
var position_last_arm_point_added: Vector2
var slow: int = 0


func _ready() -> void:
	_add_arm_point()
	arm_stretch_sounds()


func _process(delta: float) -> void:
	if not is_stunned():
		if Input.is_action_just_pressed("Click"):
			if bodies_able_to_pick_up.size() > 0:
				var rigidbody: RigidBody2D = bodies_able_to_pick_up[0]
				holding = rigidbody
				holding_local_offset = to_local(holding.global_position)
				holding_global_rotation_on_pickup = holding.global_rotation
				hand_rotation_on_pickup = global_rotation
				var grab_sound := grab_sound_scene.instantiate()
				add_sibling(grab_sound)
		elif Input.is_action_just_released("Click"):
			holding = null

	if arm_point.global_position.distance_to(position_last_arm_point_added) >= create_arm_point_distance:
		_add_arm_point()
	arm_line.set_point_position(arm_line.get_point_count() - 1, arm_point.global_position)

	stretch_1.volume_db = lerp(min_volume_stretch_db, 0.0, clampf(linear_velocity.length() / max_speed, 0, 1))
	stretch_2.volume_db = lerp(min_volume_stretch_db, 0.0, clampf(linear_velocity.length() / max_speed, 0, 1))


func _physics_process(delta: float) -> void:
	if not is_stunned():
		var target_global_position := get_global_mouse_position()
		target_global_position = global_position.lerp(target_global_position, clampf(move_speed * delta, 0, 1))
		var max_speed_to_use := slow_max_speed if is_slow() else max_speed
		target_global_position = global_position.move_toward(target_global_position, max_speed_to_use * delta)
		linear_velocity = (target_global_position - global_position) / delta

		var target_global_rotation: float
		var threshold := slow_rotate_linear_speed_threshold if is_slow() else rotate_linear_speed_threshold
		if linear_velocity.length() >= threshold:
			target_global_rotation = linear_velocity.angle()
			target_global_rotation = lerp_angle(global_rotation, target_global_rotation, clampf(rotate_speed * delta, 0, 1))
		else:
			target_global_rotation = global_rotation
		angular_velocity = (target_global_rotation - global_rotation) / delta

	if is_instance_valid(holding):
		holding.linear_velocity = (to_global(holding_local_offset) - holding.global_position) / delta
		var holding_target_global_rotation = holding_global_rotation_on_pickup + (global_rotation - hand_rotation_on_pickup)
		# Works better just setting the rotation for some reason
		#holding.angular_velocity = (holding_target_global_rotation - holding.global_rotation) / delta
		holding.global_rotation = holding_target_global_rotation


func _on_pick_up_area_body_entered(body: Node2D) -> void:
	bodies_able_to_pick_up.append(body)


func _on_pick_up_area_body_exited(body: Node2D) -> void:
	bodies_able_to_pick_up.erase(body)


func hit(position_hit_from: Vector2, sound_scene: PackedScene) -> void:
	time_last_hit = Time.get_ticks_msec()
	apply_impulse(hit_impulse * (global_position - position_hit_from).normalized())
	holding = null

	var ouch: Node2D = ouch_scene.instantiate()
	ouch.global_position = global_position
	add_sibling(ouch)

	var sound := sound_scene.instantiate()
	add_sibling(sound)

	await get_tree().create_timer(ouch_lifetime).timeout
	ouch.queue_free()


func is_stunned() -> bool:
	return time_last_hit + hit_cooldown * 1000 > Time.get_ticks_msec()


func is_slow() -> bool:
	return slow > 0 or (is_instance_valid(holding) and holding.get_meta("slow", false))


func _add_arm_point() -> void:
	arm_line.add_point(arm_point.global_position)
	position_last_arm_point_added = arm_point.global_position


func _on_body_shape_entered(body_rid: RID, body: Node, body_shape_index: int, local_shape_index: int) -> void:
	if body is TileMapLayer:
		var wall_hit_sound := wall_hit_sound_scene.instantiate()
		add_sibling(wall_hit_sound)

	if body is not RigidBody2D: return
	var body_rb := body as RigidBody2D
	var collision_shape: CollisionShape2D = body_rb.shape_owner_get_owner(body_rb.shape_find_owner(body_shape_index))

	if collision_shape.get_meta("hit", false):
		var sound: PackedScene
		print(body.name)
		if body.get_meta("knife", false):
			sound = knife_hurt_sound_scene
		elif body.get_meta("pin", false):
			sound = pin_hurt_sound_scene
		else:
			sound = knife_hurt_sound_scene
		hit(collision_shape.global_position, sound)
	if collision_shape.get_meta("slow", false):
		var sound := glue_hurt_sound_scene.instantiate()
		add_sibling(sound)
		slow += 1


func _on_body_shape_exited(body_rid: RID, body: Node, body_shape_index: int, local_shape_index: int) -> void:
	if body is not RigidBody2D: return
	var body_rb := body as RigidBody2D
	var collision_shape: CollisionShape2D = body_rb.shape_owner_get_owner(body_rb.shape_find_owner(body_shape_index))

	if collision_shape.get_meta("slow", false):
		slow -= 1


func arm_stretch_sounds() -> void:
	while true:
		stretch_1.play()
		await get_tree().create_timer(40).timeout
		stretch_2.play()
		await get_tree().create_timer(40).timeout
