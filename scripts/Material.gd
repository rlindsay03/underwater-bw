extends Area2D

signal collected

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	add_to_group("materials")

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		collected.emit()
		queue_free()
