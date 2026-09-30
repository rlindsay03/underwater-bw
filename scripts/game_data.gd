extends Node

var materials_collected: int = 0
var total_materials: int = 0
var weave_accuracy: float = 0.0
var final_score: float = 0.0
var stars: int = 0

func calculate_final_score() -> void:
	var materials_ratio := 0.0
	if total_materials > 0:
		materials_ratio = float(materials_collected) / float(total_materials)

	final_score = weave_accuracy * materials_ratio

	if final_score >= 0.75:
		stars = 3
	elif final_score >= 0.5:
		stars = 2
	elif final_score >= 0.25:
		stars = 1
	else:
		stars = 0

func reset() -> void:
	materials_collected = 0
	total_materials = 0
	weave_accuracy = 0.0
	final_score = 0.0
	stars = 0
