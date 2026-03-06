extends BotState

@export var damage: int = 10
@export var attack_speed: float = 5.0
@export var attack_delay_duration: float = 1

var timer: float = 0.0

func enter() -> void:
	super()
	timer = attack_delay_duration

func process_physics(delta) -> void:
	timer -= delta
	
	if timer <= 0 and enemy_body.has_method("take_damage"):
		enemy_body.take_damage(damage, attack_speed, char_body, Callable(self, "play_attack_animation"))

func play_attack_animation() -> void:
	animation.play("attack")

func _on_attack_range_body_shape_exited(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if !body is CharacterBody2D:
		return
	
	transitioned.emit(self, "follow", body)
