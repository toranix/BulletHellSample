extends Node2D

var stage = preload("res://Objects/Stage.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	Engine.set_target_fps(GlobalConstants.FRAMERATE)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	update_debug()

func update_debug() -> void:
	if !GlobalVariables.debug: return
	$Debug/FramerateLabel.text = str(Engine.get_frames_per_second())
	$Debug/BulletCountLabel.text = str(GlobalVariables.active_bullet_count)
	$Debug/MemoryLabel.text = str(Performance.get_monitor(Performance.MEMORY_STATIC)/1024.0/1024.0).pad_decimals(2) + " MB"

func start_game():
	$MainMenu.set_process(false)
	$MainMenu.hide()
	var newStage = stage.instantiate()
	newStage.name = "Stage0"
	add_child(newStage)
