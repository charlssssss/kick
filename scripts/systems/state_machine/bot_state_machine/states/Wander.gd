extends BotState

var move_direction: Vector2
var wander_time: float

func enter() -> void:
	super();
	randomize_wander()

func process_frame(delta: float) -> void:
	if wander_time > 0:
		wander_time -= delta
	else:
		randomize_wander()
	animation.flip_h = move_direction.x < 0

func process_physics(_delta: float) -> void:
	char_body.velocity = move_direction * move_speed
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


func randomize_wander() -> void:
	move_direction = Vector2(randf_range(-1, 1), randf_range(-1, 2)).normalized()
	wander_time = randf_range(1, 3)
	

func _on_bot_follow_range_body_entered(body: Node2D) -> void:
	if !body is CharacterBody2D:
		return
		
	transitioned.emit(self, "follow", body)
