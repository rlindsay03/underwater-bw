extends Area2D

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		call_deferred("_go_to_weave_scene")

func _go_to_weave_scene() -> void:
	get_tree().change_scene_to_file("res://scenes/Weave.tscn")
