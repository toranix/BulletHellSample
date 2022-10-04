extends Control
class_name Menu

var selected_button : int
var has_given_input : bool
var inputs = ["down", "up", "confirm"]

# Called when the node enters the scene tree for the first time.
func _ready():
	has_given_input = false
	select_button(0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	# Check if input was held from before, don't take new input if so
	if (has_given_input):
		for input in inputs:
			var input_strength = Input.get_action_strength(input)
			if input_strength == 1: return
	has_given_input = false
	
	# Check for selection menu options
	var selection_delta : int = Input.get_action_strength("down") - Input.get_action_strength("up")
	if selection_delta != 0:
		var new_selection : int = (selection_delta + selected_button + $Buttons.get_child_count()) % $Buttons.get_child_count()
		has_given_input = true
		select_button(new_selection)
		return
	
	_handle_extra_input()

func _handle_extra_input() -> void:
	pass

# Sets appropriate button as selected (and all others as deselected)
func select_button(index : int) -> void:
	if (index >= $Buttons.get_child_count()):
		select_button(0)
		return
	for i in $Buttons.get_child_count():
		$Buttons.get_child(i).is_selected = i == index
	selected_button = index
