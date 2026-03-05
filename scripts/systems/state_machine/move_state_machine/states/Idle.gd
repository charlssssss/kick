extends MoveState

func process_input(_event: InputEvent) -> void:
	var direction = Input.get_vector("left", "right", "up", "down")
	
	if direction != Vector2.ZERO:
		transitioned.emit(self, "run")
		return
