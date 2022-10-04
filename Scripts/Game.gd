extends Node2D

var stage = preload("res://Objects/Stage.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	Engine.set_target_fps(Global.FRAMERATE)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	update_debug()

func update_debug() -> void:
	if !Global.debug: return
	$Debug/FramerateLabel.text = str(Engine.get_frames_per_second())
	$Debug/BulletCountLabel.text = str(Global.active_bullet_count)
	$Debug/MemoryLabel.text = str(Performance.get_monitor(Performance.MEMORY_STATIC)/1024.0/1024.0).pad_decimals(2) + " MB"

func start_game() -> void:
	$MainMenu.set_process(false)
	$MainMenu.hide()
	var new_stage = stage.instantiate()
	$StageContainer.add_child(new_stage)

func restart_game() -> void:
	$StageContainer.get_child(0).queue_free()
	start_game()
	
func main_menu() -> void:
	$StageContainer.get_child(0).queue_free()
	$MainMenu.set_process(true)
	$MainMenu.show()
