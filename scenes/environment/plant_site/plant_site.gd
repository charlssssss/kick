extends Area2D

@export var main_ui: Node2D
@export var site_label: Label
@export var site_string:= ""

func _ready() -> void:
	if site_label:
		site_label.text = site_string
	
	self.body_entered.connect(_on_body_entered)
	self.body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node2D) -> void:
	if body is Character and body.is_spike_carrier and body.has_method("set_in_plant_site"):
		body.set_in_plant_site(true)

func _on_body_exited(body: Node2D) -> void:
	if body is Character and body.is_spike_carrier and body.has_method("set_in_plant_site"):
		body.set_in_plant_site(false)
