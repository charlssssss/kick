extends BotState

@export var duration: float = 0.2
@export var bot_follow_range: Area2D
var knockback_velocity: Vector2 = Vector2.ZERO
var timer: float = 0.0

func enter() -> void:
	timer = duration
	bot_follow_range.monitoring = false
	call_deferred("_start_knockback_animation")

func process_physics(delta) -> void:
	timer -= delta
	
	char_body.velocity = knockback_velocity
	char_body.move_and_slide()
	
	knockback_velocity = knockback_velocity.move_toward(Vector2.ZERO, 2000 * delta)
	
	if timer <= 0:
		bot_follow_range.monitoring = true
		transitioned.emit(self, "wander", null)

func _start_knockback_animation() -> void:
	animation.animation = animation_name
	animation.frame = 0
