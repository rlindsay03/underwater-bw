extends Node2D

@onready var breath_timer: Timer = $BreathTimer
@onready var breath_bar: ProgressBar = $CanvasLayer/Control/BreathBar
@onready var player: CharacterBody2D = $Player/CharacterBody2D
@onready var instruction_label: Label = $CanvasLayer/Control/Instructions
@onready var instruction_rect: ColorRect = $CanvasLayer/Control/InstructionsColorRect
@onready var exit_hint_label: Label = $CanvasLayer/Control/ExitHint
@onready var exit_rect: ColorRect = $CanvasLayer/Control/ExitColorRect

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
	instruction_label.visible = true
	instruction_rect.visible = true
	exit_hint_label.visible = false
	exit_rect.visible = false

	var materials = get_tree().get_nodes_in_group("materials")
	GameData.total_materials = materials.size()
	for m in materials:
		m.collected.connect(_on_material_collected)

func _process(delta: float) -> void:
	if breath_timer.time_left > 0:
		breath_bar.value = breath_timer.time_left

func _on_breath_timer_timeout() -> void:
	get_tree().change_scene_to_file("res://scenes/Level0_Weave.tscn")

func _on_material_collected() -> void:
	GameData.materials_collected += 1
	player.play_collect_animation()
	print("Collected: ", GameData.materials_collected, "/", GameData.total_materials)
	if GameData.materials_collected >= GameData.total_materials:
		exit_rect.visible = true
		exit_hint_label.visible = true
