extends GPUParticles2D

@export var blood_stain_area: Area2D

var timer: float = 0.0

func _ready():
	blood_stain_area.body_entered.connect(_on_body_entered)
	var blood_stain_area_duration = lifetime * 0.65
	timer = blood_stain_area_duration

func _process(delta: float):
	timer -= delta
	if timer <= 0 and blood_stain_area != null:
		blood_stain_area.queue_free()

func _on_body_entered(body: Character) -> void:
	if body.has_method("make_footprint_bloody"):
		var bloody_footprint_duration = timer * 0.35
		body.make_footprint_bloody(bloody_footprint_duration)
