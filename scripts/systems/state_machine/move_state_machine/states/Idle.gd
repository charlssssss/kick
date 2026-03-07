extends MoveState

func process_input(event: InputEvent) -> void:
	if char_body.is_in_the_plant_site and event.is_action_pressed("plant"):
		transitioned.emit(self, "plant")
		return
	
	var direction = Input.get_vector("left", "right", "up", "down")
	
	if direction != Vector2.ZERO:
		transitioned.emit(self, "run")
		return
