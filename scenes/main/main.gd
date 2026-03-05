extends Node2D

var score: int = 0
@export var score_label: Label

func add_score(amount: int) -> void:
	score += amount
	score_label.text = "score: %d" % score
