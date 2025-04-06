extends RigidBody2D
class_name Hand


@export var move_speed: float
@export var max_speed: float
@export var rotate_speed: float
@export var rotate_linear_speed_threshold: float
@export_flags_2d_physics var pick_up_mask: int

var holding: RigidBody2D = null

var holding_local_offset: Vector2

var bodies_able_to_pick_up: Array[RigidBody2D] = []


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Click"):
		if bodies_able_to_pick_up.size() > 0:
			var rigidbody: RigidBody2D = bodies_able_to_pick_up[0]
			holding = rigidbody
			holding_local_offset = to_local(holding.global_position)
	elif Input.is_action_just_released("Click"):
		holding = null


func _physics_process(delta: float) -> void:
	var target_global_position := get_global_mouse_position()
	target_global_position = global_position.lerp(target_global_position, clampf(move_speed * delta, 0, 1))
	target_global_position = global_position.move_toward(target_global_position, max_speed * delta)
	linear_velocity = (target_global_position - global_position) / delta

	var target_global_rotation: float
	if linear_velocity.length() >= rotate_linear_speed_threshold:
		target_global_rotation = linear_velocity.angle()
		target_global_rotation = lerp_angle(global_rotation, target_global_rotation, clampf(rotate_speed * delta, 0, 1))
	else:
		target_global_rotation = global_rotation
	angular_velocity = (target_global_rotation - global_rotation) / delta

	if is_instance_valid(holding):
		holding.linear_velocity = (to_global(holding_local_offset) - holding.global_position) / delta


func _on_pick_up_area_body_entered(body: Node2D) -> void:
	bodies_able_to_pick_up.append(body)


func _on_pick_up_area_body_exited(body: Node2D) -> void:
	bodies_able_to_pick_up.erase(body)
