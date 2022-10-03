extends Control

var selectedButton : int
var hasGivenInput : bool

# Called when the node enters the scene tree for the first time.
func _ready():
	hasGivenInput = false
	_select_button(0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	# Check if input was held from before, don't take new input if so
	if (hasGivenInput):
		for input in ["down", "up", "confirm"]:
			var inputStrength = Input.get_action_strength(input)
			if inputStrength == 1: return
	hasGivenInput = false
	
	# Check for selection menu options
	var selectionDelta : int = Input.get_action_strength("down") - Input.get_action_strength("up")
	if selectionDelta != 0:
		var newSelection : int = (selectionDelta + selectedButton + $Buttons.get_child_count()) % $Buttons.get_child_count()
		hasGivenInput = true
		_select_button(newSelection)
		return
		
	# Check for confirming menu option
	var isConfirmed : bool = Input.get_action_strength("confirm")
	if isConfirmed:
		var selected = $Buttons.get_children().filter(func(button): return button.isSelected)[0]
		hasGivenInput = true
		match selected.text.strip_edges():
			"Start Game":
				get_node("/root/Game").start_game()
			"Filler":
				print("Filler chosen")
			"Exit":
				get_tree().quit()

# Sets appropriate button as selected (and all others as deselected)
func _select_button(index : int) -> void:
	if (index >= $Buttons.get_child_count()):
		_select_button(0)
		return
	for i in $Buttons.get_child_count():
		$Buttons.get_child(i).isSelected = i == index
	selectedButton = index
