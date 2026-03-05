extends Node
class_name MoveState

signal transitioned

@export var animation_name: String
@export var sprint_speed: float = 400
@export var walk_speed: float = 200

var char_body: CharacterBody2D
var animation: AnimatedSprite2D
var facing_direction: Vector2

func enter() -> void:
	animation.play(animation_name)

func exit() -> void:
	pass

func process_input(_event: InputEvent) -> void:
	pass

func process_frame(_delta: float) -> void:
	if facing_direction:
		animation.flip_h = facing_direction.x < 0
	else:
		animation.flip_h = char_body.get_global_mouse_position().x < char_body.global_position.x

func process_physics(_delta: float) -> void:
	pass
