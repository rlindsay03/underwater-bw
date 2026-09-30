extends CharacterBody2D

@export var speed: float = 75.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var is_collecting := false

func play_collect_animation() -> void:
	is_collecting = true
	animated_sprite.play("collect")
	await animated_sprite.animation_finished
	is_collecting = false

func _physics_process(delta: float) -> void:
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = input_dir * speed
	move_and_slide()
	
	add_to_group("player")

	if is_collecting:
		return
	if input_dir.length() > 0:
		animated_sprite.play("walk")
	else:
		animated_sprite.play("idle")
