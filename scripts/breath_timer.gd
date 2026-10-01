extends Node2D

@onready var breath_timer: Timer = $BreathTimer
@onready var breath_bar: ProgressBar = $CanvasLayer/Control/BreathBar
@onready var player: CharacterBody2D = $Player/CharacterBody2D
@onready var pause_menu: Control = $CanvasLayer/Control/PauseMenu

var breath_time: float
var materials_collected: int = 0
var total_materials: int = 0

func _ready() -> void:
	GameData.reset()
	breath_time = breath_timer.wait_time
	breath_bar.max_value = breath_time
	breath_bar.value = breath_time
	breath_timer.timeout.connect(_on_breath_timer_timeout)
	breath_timer.start()

	var materials = get_tree().get_nodes_in_group("materials")
	GameData.total_materials = materials.size()
	for m in materials:
		m.collected.connect(_on_material_collected)

func _process(delta: float) -> void:
	if breath_timer.time_left > 0:
		breath_bar.value = breath_timer.time_left

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		_toggle_pause()

func _toggle_pause() -> void:
	get_tree().paused = not get_tree().paused
	pause_menu.visible = get_tree().paused

func _on_breath_timer_timeout() -> void:
	get_tree().change_scene_to_file("res://scenes/Weave.tscn")

func _on_material_collected() -> void:
	GameData.materials_collected += 1
	player.play_collect_animation()
	print("Collected: ", GameData.materials_collected, "/", GameData.total_materials)
