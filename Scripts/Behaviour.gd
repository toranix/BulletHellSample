extends Node
class_name Behaviour

signal waited
var started : bool
var obj

func _ready() -> void:
	started = false
	obj = get_parent()
	set_process(true)

func _process(_delta) -> void:
	if !started:
		start_behaviour()
	waited.emit()

func start_behaviour() -> void:
	started = true
	run_behaviour()
	
func run_behaviour() -> void:
	pass

func wait(n : int) -> void:
	for i in n:
		if obj: await waited
