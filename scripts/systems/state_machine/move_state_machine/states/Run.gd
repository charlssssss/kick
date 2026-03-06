extends MoveState

@export var blood_footprint_scene: PackedScene
@export var left_foot_marker: Marker2D
@export var right_foot_marker: Marker2D
@export var min_step_distance := 10.0
@export var max_step_distance := 20.0
@export var min_footprint_scale := 0.8
@export var max_footprint_scale := 1.5

@export var blood_stain_area_duration := 7

var last_footprint_pos := Vector2.ZERO
var use_left_foot := true

func process_physics(_delta: float) -> void:
	var direction = Input.get_vector("left", "right", "up", "down")
	
	if direction == Vector2.ZERO:
		transitioned.emit(self, "idle")
		char_body.velocity = Vector2.ZERO
		return
	
	var sprinting = Input.is_action_pressed("sprint") and char_body.stamina > 0
	var current_speed = sprint_speed if sprinting else walk_speed
	
	direction = direction.normalized()
	char_body.velocity = direction * current_speed
	char_body.move_and_slide()
	
	var step_distance = randf_range(min_step_distance, max_step_distance)
	var step_distance_with_stamina = step_distance * 2 if sprinting else step_distance
	
	if char_body.has_bloody_footprint:
		var bloody_percentage = ((char_body.bloody_timer / blood_stain_area_duration) * 100) / 100
		max_footprint_scale = max(max_footprint_scale * bloody_percentage, min_footprint_scale)
		
		if last_footprint_pos == Vector2.ZERO:
			last_footprint_pos = char_body.global_position
			spawn_blood_footprint()
		else:
			if char_body.global_position.distance_to(last_footprint_pos) >= step_distance_with_stamina:
				spawn_blood_footprint()
				last_footprint_pos = char_body.global_position
	
	var pushed_bodies := {}
	
	for i in range(char_body.get_slide_collision_count()):
		var collision = char_body.get_slide_collision(i)
		var collider = collision.get_collider()
		
		if collider is RigidBody2D and not pushed_bodies.has(collider):
			var push_dir = -collision.get_normal()
			var target_velocity = push_dir * 300
			collider.linear_velocity = collider.linear_velocity.lerp(target_velocity, 0.4)
			pushed_bodies[collider] = true

func spawn_blood_footprint() -> void:
	if blood_footprint_scene == null:
		return
	
	var footprint = blood_footprint_scene.instantiate()
	
	if use_left_foot:
		footprint.scale 
		footprint.global_position = left_foot_marker.global_position
	else:
		footprint.global_position = right_foot_marker.global_position
	
	var scale_factor = randf_range(min_footprint_scale, max_footprint_scale)
	footprint.scale = Vector2.ONE * scale_factor
	
	get_tree().current_scene.add_child(footprint)
	
	use_left_foot = !use_left_foot
