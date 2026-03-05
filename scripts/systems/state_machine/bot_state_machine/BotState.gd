extends Node
class_name BotState

signal transitioned

@export var animation_name: String
@export var move_speed: float = 400

var char_body: CharacterBody2D
var enemy_body: CharacterBody2D
var animation: AnimatedSprite2D

func enter() -> void:
	animation.play(animation_name)

func exit() -> void:
	pass

func process_input(_event: InputEvent) -> void:
	pass

func process_frame(_delta: float) -> void:
	pass

func process_physics(_delta: float) -> void:
	pass
