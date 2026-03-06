extends BotState

func process_physics(_delta: float) -> void:
	follow_enemy()

func follow_enemy() -> void:
	if !enemy_body:
		return
	var direction = char_body.global_position.direction_to(enemy_body.global_position)
	animation.flip_h = direction.x < 0
	char_body.velocity = direction * move_speed
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

func _on_bot_follow_range_body_exited(_body: Node2D) -> void:
	transitioned.emit(self, "wander", null)


func _on_attack_range_body_entered(body: Node2D) -> void:
	if !body is CharacterBody2D:
		return
	
	transitioned.emit(self, "attack", body)
