extends MoveState

@export var exhaust_time: float = 3.0
var timer: float

func enter() -> void:
	timer = exhaust_time
	char_body.velocity = Vector2.ZERO
	super()

func process_physics(delta):
	timer -= delta
	
	char_body.velocity = Vector2.ZERO
	char_body.move_and_slide()

	if timer <= 0:
		transitioned.emit(self, "idle")
		return
