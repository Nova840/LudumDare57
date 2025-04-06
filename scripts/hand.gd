extends RigidBody2D
class_name Hand


@export var hand_move_speed: float
@export var hand_max_speed: float
@export_flags_2d_physics var pick_up_mask: int

var holding: RigidBody2D = null

var holding_local_offset: Vector2


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Click"):
		var space := get_world_2d().direct_space_state
		var parameters := PhysicsPointQueryParameters2D.new()
		parameters.position = get_global_mouse_position()
		parameters.collision_mask = pick_up_mask
		var result := space.intersect_point(parameters)
		for i in range(result.size() - 1, -1, -1):
			if result[i]["collider"] is not RigidBody2D:
				result.remove_at(i)
		if result.size() > 0:
			var rigidbody: RigidBody2D = result[0]["collider"]
			holding = rigidbody
			holding_local_offset = to_local(holding.global_position)
	elif Input.is_action_just_released("Click"):
		holding = null


func _physics_process(delta: float) -> void:
	var target_global_position := get_global_mouse_position()
	target_global_position = global_position.lerp(target_global_position, clampf(hand_move_speed * delta, 0, 1))
	target_global_position = global_position.move_toward(target_global_position, hand_max_speed * delta)
	linear_velocity = (target_global_position - global_position) / delta

	if is_instance_valid(holding):
		holding.linear_velocity = (to_global(holding_local_offset) - holding.global_position) / delta
