extends MoveState

func process_physics(_delta: float) -> void:
	var direction = Input.get_vector("left", "right", "up", "down")
	
	if direction == Vector2.ZERO:
		transitioned.emit(self, "idle")
		char_body.velocity = Vector2.ZERO
		return
	
	var sprinting = Input.is_action_pressed("sprint") and char_body.stamina > 0
	var current_speed = sprint_speed if sprinting else walk_speed
	
	direction = direction.normalized()
	char_body.velocity = direction * current_speed
	char_body.move_and_slide()
	
	var pushed_bodies := {}
	
	for i in range(char_body.get_slide_collision_count()):
		var collision = char_body.get_slide_collision(i)
		var collider = collision.get_collider()
		
		if collider is RigidBody2D and not pushed_bodies.has(collider):
			var push_dir = -collision.get_normal()
			var target_velocity = push_dir * 300
			collider.linear_velocity = collider.linear_velocity.lerp(target_velocity, 0.4)
			pushed_bodies[collider] = true
