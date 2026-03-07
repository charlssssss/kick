extends Character

signal game_over

@export var animation: AnimatedSprite2D
@export var move_state_machine: MoveStateMachine

@export var push_area: Area2D
@export var push_force: float = 500.0
@export var push_damage: float = 10.0

@export var sprint_drain_rate: float = 30.0
@export var stamina_recovery_rate: float = 20.0
@export var recovery_delay: float = 3.0

var recovery_timer: float = 0.0
var hide_progress_bar_duration: float = 0.5
var hide_progress_bar_timer: float = 0.0
var was_full_stamina := true

var drain_stamina_timer: float = 0.0
var exhaust_delay: float = 2.0 

var damage_cooldown: float = 0.0

func _ready() -> void:
	apply_bars()
	move_state_machine.init(self, animation)

func _unhandled_input(event: InputEvent) -> void:
	move_state_machine.process_input(event)

func _process(delta: float) -> void:
	move_state_machine.process_frame(delta)
	toggle_stamina_bar(delta)

func _physics_process(delta: float) -> void:
	move_state_machine.process_physics(delta)
	
	var is_sprinting = Input.is_action_pressed("sprint") and velocity.length() > 0
	update_stamina(delta, is_sprinting)
	
	var is_player_exhausted = is_exhausted(delta)
	if Input.is_action_just_pressed("push") and stamina > 0 and move_state_machine.current_state.name != "Exhaust":
		push_bodies()
	
	if is_player_exhausted:
		move_state_machine.transition_to("exhaust")
	
	if damage_cooldown > 0:
		damage_cooldown -= delta

func push_bodies() -> void:
	var bodies = push_area.get_overlapping_bodies()
	
	for body in bodies:
		if body == self:
			continue
		
		var direction = (body.global_position - global_position).normalized()
		
		var push_force_with_stamina = push_force * (stamina / 100.0)
		
		if body.has_method("apply_knockback"):
			body.apply_knockback(direction * push_force_with_stamina)
		
		if body is CharacterBody2D:
			body.velocity += direction * push_force_with_stamina
			
			if body.has_method("take_damage"):
				var push_damage_with_stamina = push_damage * (stamina / 100.0)
				body.take_damage(push_damage_with_stamina, self)
		elif body is RigidBody2D:
			body.apply_impulse(direction * push_force_with_stamina)
	
	if bodies.size() > 1:
		update_stamina(1, true)

func update_stamina(delta: float, is_sprinting: bool):
	if is_sprinting and stamina > 0:
		stamina_bar.visible = true
		
		stamina -= sprint_drain_rate * delta
		stamina = max(stamina, 0)
		
		recovery_timer = recovery_delay
		was_full_stamina = false
		
	else:
		if recovery_timer > 0:
			recovery_timer -= delta
		else:
			if stamina < max_stamina:
				stamina_bar.visible = true
				
				stamina += stamina_recovery_rate * delta
				stamina = min(stamina, max_stamina)
			
	stamina_bar.value = stamina
	
	if stamina >= max_stamina and !was_full_stamina:
		hide_progress_bar_timer = hide_progress_bar_duration
		was_full_stamina = true

func toggle_stamina_bar(delta: float) -> void:
	if was_full_stamina:
		hide_progress_bar_timer -= delta
		
		if hide_progress_bar_timer <= 0:
			stamina_bar.visible = false

func is_exhausted(delta: float) -> bool:
	if stamina <= 0:
		drain_stamina_timer += delta
	else:
		drain_stamina_timer = 0.0
	
	return drain_stamina_timer >= exhaust_delay and move_state_machine.current_state.name != "Exhaust" and (Input.is_action_pressed("sprint") or Input.is_action_just_pressed("push"))

func take_damage(damage: int,  attack_speed: float, enemy_body: CharacterBody2D, attack_callback: Callable) -> void:
	if health > 0:
		if damage_cooldown > 0:
			return
		
		health -= damage
		health_bar.health = health
		
		spawn_blood(enemy_body)
		show_floating_text(damage)
		attack_callback.call()
		
		damage_cooldown = attack_speed
	else:
		game_over.emit()
