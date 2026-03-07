extends CharacterBody2D
class_name Character

@export var health_bar: ProgressBar
@export var stamina_bar: ProgressBar

@export var health: int = 100
@export var max_stamina: float = 100.0
@export var stamina: float = 0.0

@export var floating_text_scene: PackedScene
@export var blood_effect_scene: PackedScene

@export var blood_footprint_scene: PackedScene
@export var left_foot_marker: Marker2D
@export var right_foot_marker: Marker2D
@export var min_step_distance:= 10.0
@export var max_step_distance:= 20.0
@export var min_footprint_scale:= 0.8
@export var max_footprint_scale:= 1.5
@export var blood_stain_area_duration:= 7
@export var is_spike_carrier:= false

var bloody_timer: float = 0.0
var has_bloody_footprint:= false

var last_footprint_pos:= Vector2.ZERO
var use_left_foot:= true

var is_in_the_plant_site:= false

func apply_bars() -> void:
	health_bar.init_health(health)
	
	if stamina_bar != null:
		stamina_bar.max_value = max_stamina
		stamina_bar.value = stamina
		stamina_bar.visible = false

func apply_blood(delta: float) -> void:
	if bloody_timer > 0:
		bloody_timer -= delta
	elif has_bloody_footprint:
		has_bloody_footprint = false
	
	var direction = Input.get_vector("left", "right", "up", "down")
	
	var sprinting = Input.is_action_pressed("sprint") and stamina > 0
	
	var step_distance = randf_range(min_step_distance, max_step_distance)
	var step_distance_with_stamina = step_distance * 2 if sprinting else step_distance
	
	if has_bloody_footprint:
		var bloody_percentage = ((bloody_timer / blood_stain_area_duration) * 100) / 100
		max_footprint_scale = max(max_footprint_scale * bloody_percentage, min_footprint_scale)
		
		if last_footprint_pos == Vector2.ZERO:
			last_footprint_pos = global_position
			spawn_blood_footprint()
		else:
			if global_position.distance_to(last_footprint_pos) >= step_distance_with_stamina:
				spawn_blood_footprint()
				last_footprint_pos = global_position

func apply_push_body_physics() -> void:
	var pushed_bodies := {}
	
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		
		if collider is RigidBody2D and not pushed_bodies.has(collider):
			var push_dir = -collision.get_normal()
			var target_velocity = push_dir * 300
			collider.linear_velocity = collider.linear_velocity.lerp(target_velocity, 0.4)
			pushed_bodies[collider] = true

func show_floating_text(damage: int) -> void:
	var text_node = floating_text_scene.instantiate()
	text_node.position = global_position
	text_node.text = str(damage)
	
	get_tree().current_scene.add_child(text_node)
	
func spawn_blood(enemy_body: CharacterBody2D):
	var blood = blood_effect_scene.instantiate()
	get_tree().current_scene.add_child(blood)
	
	blood.position = global_position
	blood.rotation = enemy_body.global_position.angle_to_point(global_position)
	blood.emitting = true

func make_footprint_bloody(bloody_duration: float) -> void:
	bloody_timer = max(bloody_duration, bloody_timer)
	has_bloody_footprint = true

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

func set_in_plant_site(is_in_plant_site: bool) -> void:
	if is_spike_carrier:
		is_in_the_plant_site = is_in_plant_site
