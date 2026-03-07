extends BotState

var current_speed: float = 0.0

func process_physics(delta: float) -> void:
	if !enemy_body:
		return
	
	var direction = char_body.global_position.direction_to(enemy_body.global_position)
	current_speed = move_toward(current_speed, move_speed, 300 * delta)
	animation.flip_h = direction.x < 0
	char_body.velocity = direction * current_speed
	char_body.move_and_slide()
	char_body.apply_blood(delta)
	char_body.apply_push_body_physics()

func _on_bot_follow_range_body_exited(_body: Node2D) -> void:
	transitioned.emit(self, "wander", null)

func _on_attack_range_body_entered(body: Node2D) -> void:
	if !body is CharacterBody2D:
		return
	
	transitioned.emit(self, "attack", body)
