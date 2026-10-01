extends Control

func _on_resume_pressed() -> void:
	get_tree().paused = false
	visible = false

func _on_quit_to_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Menu.tscn")
