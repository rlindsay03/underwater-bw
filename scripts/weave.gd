extends Control

@onready var prompt_label: Label = $PromptLabel
@onready var timer_bar: ProgressBar = $TimerBar
@onready var score_label: Label = $ScoreLabel

const DIRECTIONS = ["left", "right", "up", "down"]
const TIME_PER_PROMPT := 1.2
const SEQUENCE_LENGTH := 8

var sequence: Array = []
var current_index := 0
var correct_hits := 0
var time_left := 0.0
var accepting_input := true

func _ready() -> void:
	for i in SEQUENCE_LENGTH:
		sequence.append(DIRECTIONS[randi() % DIRECTIONS.size()])
	_show_current_prompt()

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
	else: return
	_register_result(pressed == sequence[current_index])

func _register_result(correct: bool) -> void:
	accepting_input = false
	if correct:
		correct_hits += 1
	current_index += 1
	score_label.text = "Hits: %d/%d" % [correct_hits, sequence.size()]
	_show_current_prompt()

func _finish_weave() -> void:
	var weave_accuracy := float(correct_hits) / float(sequence.size())
	prompt_label.text = "Done!"
	print("Weave accuracy: ", weave_accuracy)
	# TODO: combine with materials_collected/total_materials for final score
