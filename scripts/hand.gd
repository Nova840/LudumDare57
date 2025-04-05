extends Node2D
class_name Hand


var holding: RigidBody2D = null


func _process(delta: float) -> void:
	global_position = get_global_mouse_position()

	if Input.is_action_just_pressed("Click"):
		var space := get_world_2d().direct_space_state
		var parameters := PhysicsPointQueryParameters2D.new()
		parameters.position = get_global_mouse_position()
		var result := space.intersect_point(parameters)
		for i in range(result.size() - 1, -1, -1):
			if result[i]["collider"] is not RigidBody2D:
				result.remove_at(i)
		if result.size() > 0:
			var rigidbody: RigidBody2D = result[0]["collider"]
			holding = rigidbody
	elif Input.is_action_just_released("Click"):
		holding = null


func _physics_process(delta: float) -> void:
	if is_instance_valid(holding):
		holding.linear_velocity = (get_global_mouse_position() - holding.global_position) / delta
