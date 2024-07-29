extends Node2D

var score = 0
@onready var score_label = $scoreLabel

func add_point():
	score += 1
	score_label.text = "Your score is" + str(score)
