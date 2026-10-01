extends Area2D

signal collected

@onready var pickup_sound: AudioStreamPlayer2D = $PickupSound

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	add_to_group("materials")

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		collected.emit()
		_play_pickup_sound()
		queue_free()
		
func _play_pickup_sound() -> void:
	var sound: AudioStreamPlayer2D = $PickupSound
	var sound_copy := sound.duplicate()
	get_tree().current_scene.add_child(sound_copy)
	sound_copy.global_position = global_position
	sound_copy.play()
	sound_copy.finished.connect(sound_copy.queue_free)
