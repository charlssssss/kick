extends Label

@export var float_speed: float = 30.0
@export var lifetime: float = 1.0

var velocity := Vector2.UP

func _ready() -> void:
	velocity *= float_speed
	await get_tree().create_timer(lifetime).timeout
	queue_free()

func _process(delta: float) -> void:
	position += velocity * delta
	modulate.a -= delta / lifetime
