extends CharacterBody2D

@export var animation: AnimatedSprite2D
@export var bot_state_machine: BotStateMachine
@export var health_bar: ProgressBar
@export var floating_text_scene: PackedScene
@export var blood_effect_scene: PackedScene
@export var health: int = 100

func _ready() -> void:
	health_bar.init_health(health)
	bot_state_machine.init(self, animation)

func _unhandled_input(event: InputEvent) -> void:
	bot_state_machine.process_input(event)

func _process(delta: float) -> void:
	bot_state_machine.process_frame(delta)

func _physics_process(delta: float) -> void:
	bot_state_machine.process_physics(delta)

func apply_knockback(force: Vector2) -> void:	
	var knockback_state = bot_state_machine.states["knockback"]
	knockback_state.knockback_velocity = force
	bot_state_machine.transition_to("knockback")

func take_damage(damage: int, enemy_body: CharacterBody2D) -> void:
	health -= damage
	health_bar.health = health
	
	spawn_blood(enemy_body)
	show_floating_text(damage)
	
	if health_bar != null and health_bar.health <= 0:
		die()

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

func die() -> void:
	bot_state_machine.transition_to("death")
