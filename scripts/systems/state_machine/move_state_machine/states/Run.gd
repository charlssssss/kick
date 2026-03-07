extends MoveState

var current_speed: float = 0.0

func process_input(event: InputEvent) -> void:
	if char_body.is_in_the_plant_site and event.is_action_pressed("plant"):
		transitioned.emit(self, "plant")
		return

func process_physics(delta: float) -> void:
	var direction = Input.get_vector("left", "right", "up", "down")
	
	if direction == Vector2.ZERO:
		transitioned.emit(self, "idle")
		return
	
	var sprinting = Input.is_action_pressed("sprint") and char_body.stamina > 0
	
	var target_speed = sprint_speed if sprinting else walk_speed
	current_speed = move_toward(current_speed, target_speed, 300 * delta)
	
	direction = direction.normalized()
	char_body.velocity = direction * current_speed
	char_body.move_and_slide()
	
	char_body.apply_blood(delta)
	char_body.apply_push_body_physics()
