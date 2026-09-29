extends CharacterBody2D

@export var speed: float = 80.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = input_dir * speed
	move_and_slide()
	
	add_to_group("player")

	if input_dir.length() > 0:
		animated_sprite.play("walk")
	else:
		animated_sprite.play("idle")
