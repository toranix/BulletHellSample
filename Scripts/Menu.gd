extends Control
class_name Menu

var selected_button : int
var previous_frame_inputs : Dictionary = {"down": 0.0, "up": 0.0, "confirm": 1.0}
var inputs := ["down", "up", "confirm"]

# Called when the node enters the scene tree for the first time.
func _ready():
	select_button(0)
	_on_ready()

func _on_ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	# Check status of all menu-relevant inputs
	var current_frame_inputs : Dictionary = {}
	for input in inputs:
		current_frame_inputs[input] = Input.get_action_strength(input)
	
	# Handle (new) inputs
	var selection_delta = 0
	for input in inputs:
		match (input if current_frame_inputs[input] && !previous_frame_inputs[input] else null):
			"down":
				selection_delta += 1
			"up":
				selection_delta -= 1
			"confirm":
				_handle_confirm()
		
	if selection_delta != 0:
		var new_selection : int = (selection_delta + selected_button + $Buttons.get_child_count()) % $Buttons.get_child_count()
		select_button(new_selection)
	
	_handle_extra_input(current_frame_inputs)
	
	previous_frame_inputs = current_frame_inputs

func _handle_confirm() -> void:
	pass

func _handle_extra_input(current_frame_inputs : Dictionary) -> void:
	pass

# Sets appropriate button as selected (and all others as deselected)
func select_button(index : int) -> void:
	if (index >= $Buttons.get_child_count()):
		select_button(0)
		return
	for i in $Buttons.get_child_count():
		$Buttons.get_child(i).is_selected = i == index
	selected_button = index
