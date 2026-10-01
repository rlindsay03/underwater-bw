extends Control

@onready var prompt_label: Label = $PromptLabel
@onready var timer_bar: ProgressBar = $TimerBar
@onready var score_label: Label = $ScoreLabel
@onready var player: AnimatedSprite2D = $AnimatedSprite2D
@onready var basket_sprite: Sprite2D = $BasketSprite
@onready var pause_menu: Control = $PauseMenu

const DIRECTIONS = ["left", "right", "up", "down"]
const TIME_PER_PROMPT := 1.2
const SEQUENCE_LENGTH := 35

var sequence: Array = []
var current_index := 0
var correct_hits := 0
var time_left := 0.0
var accepting_input := true

func _ready() -> void:
	player.animation_finished.connect(_on_player_animation_finished)
	for i in SEQUENCE_LENGTH:
		sequence.append(DIRECTIONS[randi() % DIRECTIONS.size()])
	_show_current_prompt()
	

func _toggle_pause() -> void:
	get_tree().paused = not get_tree().paused
	pause_menu.visible = get_tree().paused
	
func _on_player_animation_finished() -> void:
	if player.animation in ["weave_success", "weave_fail"]:
		player.play("idle")

func _show_current_prompt() -> void:
	if current_index >= sequence.size():
		_finish_weave()
		return
	prompt_label.text = sequence[current_index].to_upper()
	time_left = TIME_PER_PROMPT
	timer_bar.max_value = TIME_PER_PROMPT
	accepting_input = true

func _process(delta: float) -> void:
	if current_index >= sequence.size():
		return
	time_left -= delta
	timer_bar.value = time_left

	var ratio := time_left / TIME_PER_PROMPT
	if ratio > 0.6:
		timer_bar.modulate = Color.GREEN
	elif ratio > 0.3:
		timer_bar.modulate = Color.YELLOW
	else:
		timer_bar.modulate = Color.RED

	if time_left <= 0 and accepting_input:
		_register_result(false)
		
func _unhandled_input(event: InputEvent) -> void:
	if current_index >= sequence.size() or not accepting_input:
		return
	var pressed := ""
	if event.is_action_pressed("ui_left"): pressed = "left"
	elif event.is_action_pressed("ui_right"): pressed = "right"
	elif event.is_action_pressed("ui_up"): pressed = "up"
	elif event.is_action_pressed("ui_down"): pressed = "down"
	elif event.is_action_pressed("ui_cancel"): _toggle_pause()
	else: return
	_register_result(pressed == sequence[current_index])

func _register_result(correct: bool) -> void:
	accepting_input = false
	if correct:
		correct_hits += 1
		player.play("weave_success")
	else:
		player.play("weave_fail")
	current_index += 1
	score_label.text = "Hits: %d/%d" % [correct_hits, sequence.size()]
	_show_current_prompt()

func _show_basket_result() -> void:
	var texture_path := ""
	match GameData.stars:
		3: texture_path = "res://assets/sprites/props/basket_great.png"
		2: texture_path = "res://assets/sprites/props/basket_good.png"
		1: texture_path = "res://assets/sprites/props/basket_bad.png"
		_: texture_path = "res://assets/sprites/props/basket_fail.png"
	basket_sprite.texture = load(texture_path)
	basket_sprite.visible = true

func _finish_weave() -> void:
	GameData.weave_accuracy = float(correct_hits) / float(sequence.size())
	GameData.calculate_final_score()
	prompt_label.text = "Done! " + str(GameData.stars) + " stars"
	print("Final score: ", GameData.final_score, " Stars: ", GameData.stars)
	_show_basket_result()
