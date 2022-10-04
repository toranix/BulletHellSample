extends Control
class_name Menu

var selectedButton : int
var hasGivenInput : bool
var inputs = ["down", "up", "confirm"]

# Called when the node enters the scene tree for the first time.
func _ready():
	hasGivenInput = false
	select_button(0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	# Check if input was held from before, don't take new input if so
	if (hasGivenInput):
		for input in inputs:
			var inputStrength = Input.get_action_strength(input)
			if inputStrength == 1: return
	hasGivenInput = false
	
	# Check for selection menu options
	var selectionDelta : int = Input.get_action_strength("down") - Input.get_action_strength("up")
	if selectionDelta != 0:
		var newSelection : int = (selectionDelta + selectedButton + $Buttons.get_child_count()) % $Buttons.get_child_count()
		hasGivenInput = true
		select_button(newSelection)
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
		$Buttons.get_child(i).isSelected = i == index
	selectedButton = index
