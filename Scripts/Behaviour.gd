extends Node
class_name Behaviour

var started : bool

func _ready() -> void:
	started = false

func _process(_delta) -> void:
	if !started:
		start_behaviour()

func start_behaviour() -> void:
	started = true
	run_behaviour(get_parent())
	
func run_behaviour(obj) -> void:
	pass

func wait(n : int) -> void:
	for i in n:
		while get_tree().paused:
			await get_tree().process_frame
		await get_tree().process_frame
