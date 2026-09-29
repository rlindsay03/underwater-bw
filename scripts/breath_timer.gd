extends Node2D

@onready var breath_timer: Timer = $BreathTimer
@onready var breath_bar: ProgressBar = $CanvasLayer/Control/BreathBar

var breath_time: float
var materials_collected: int = 0
var total_materials: int = 0

func _ready() -> void:
	breath_time = breath_timer.wait_time
	breath_bar.max_value = breath_time
	breath_bar.value = breath_time
	breath_timer.timeout.connect(_on_breath_timer_timeout)
	breath_timer.start()

	var materials = get_tree().get_nodes_in_group("materials")
	total_materials = materials.size()
	for m in materials:
		m.collected.connect(_on_material_collected)

func _process(delta: float) -> void:
	if breath_timer.time_left > 0:
		breath_bar.value = breath_timer.time_left

func _on_breath_timer_timeout() -> void:
	print("Collection phase over!")

func _on_material_collected() -> void:
	materials_collected += 1
	print("Collected: ", materials_collected, "/", total_materials)
