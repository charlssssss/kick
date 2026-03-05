extends Area2D

@export var main_ui: Node2D

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body) -> void:
	if body is Ball:
		if main_ui:
			main_ui.add_score(1)
		
		body.queue_free()
