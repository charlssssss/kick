extends Node2D

@export var lifetime: float = 30.0
@export var min_scale: float = 0.1
var timer: float = 0.0
var initial_scale: Vector2 = Vector2.ONE

func _ready():
	timer = lifetime
	initial_scale = scale

func _process(delta: float):
	timer -= delta
	if timer <= 0:
		queue_free()
	else:
		var t = timer / lifetime
		scale = initial_scale * (min_scale + (t * (1.0 - min_scale)))
