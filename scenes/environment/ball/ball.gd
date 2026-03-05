extends RigidBody2D
class_name Ball

@export var max_speed := 500

func _physics_process(_delta) -> void:
	if linear_velocity.length() > max_speed:
		linear_velocity = linear_velocity.normalized() * max_speed
