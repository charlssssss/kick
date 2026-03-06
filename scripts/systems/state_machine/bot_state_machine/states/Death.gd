extends BotState

func enter() -> void:
	char_body.collision_layer = 0
	char_body.collision_mask = 0
	char_body.z_index = 1
	call_deferred("_start_death_animation")

func _start_death_animation() -> void:
	animation.animation = animation_name
	animation.frame = 0
