extends MoveState

@export var planting_duration: float = 4.0
var planting_timer: float = 0.0

func enter() -> void:
	planting_timer = planting_duration
	char_body.velocity = Vector2.ZERO
	animation.play(animation_name)
	char_body.set_physics_process(true)

func process_input(_event: InputEvent) -> void:
	if not Input.is_action_pressed("plant"):
		transitioned.emit(self, "idle")
		return

func process_physics(delta: float) -> void:
	planting_timer -= delta

	char_body.velocity = Vector2.ZERO
	char_body.move_and_slide()
	
	if planting_timer <= 0:
		transitioned.emit(self, "idle")
		return
