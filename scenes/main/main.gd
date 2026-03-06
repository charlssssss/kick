extends Node2D

@export var game_over_screen: CanvasLayer
@export var score_label: Label
var score: int = 0

func add_score(amount: int) -> void:
	score += amount
	score_label.text = "score: %d" % score

func _on_player_game_over() -> void:
	get_tree().paused = true
	game_over_screen.visible = true
	
func _on_play_again_button_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_quit_button_pressed() -> void:
	get_tree().quit()
