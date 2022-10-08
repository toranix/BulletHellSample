extends Node2D

var stage = preload("res://Objects/Stage.tscn")
var behaviour = preload("res://Scripts/Stages/StageDebug.gd")

# Called when the node enters the scene tree for the first time.
func _ready():
	Engine.set_target_fps(Global.FRAMERATE)

func start_game() -> void:
	Global.active_bullet_count = 0
	$MainMenu.set_process(false)
	$MainMenu.hide()
	var new_stage = stage.instantiate()
	$StageContainer.add_child(new_stage)
	new_stage.init_stage(behaviour)
	$Debug.to_stage()

func restart_game() -> void:
	$StageContainer.get_child(0).queue_free()
	start_game()
	
func main_menu() -> void:
	$Debug.to_main_menu()
	Global.active_bullet_count = 0
	$StageContainer.get_child(0).queue_free()
	$MainMenu.set_process(true)
	$MainMenu.show()
