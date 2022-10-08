extends Control

var is_escape_previous_frame : bool

func _ready():
	randomize()
	$PauseMenu.hide()
	is_escape_previous_frame = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var is_escape : bool = Input.get_action_strength("escape")
	if (is_escape && !is_escape_previous_frame):
		Global.debug.dprint("paused")
		$PauseMenu.select_button(0)
		$PauseMenu.show()
		get_tree().paused = true
	is_escape_previous_frame = is_escape

func init_stage(init_behaviour) -> void:
	for obj in $BehaviourContainer.get_children():
		obj.queue_free()
	var new_node = Node.new()
	$BehaviourContainer.add_child(new_node)
	new_node.set_script(init_behaviour)
	new_node._ready()
