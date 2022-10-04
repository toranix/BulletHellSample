extends Menu

func _ready() -> void:
	inputs = ["down", "up", "confirm", "escape"]
	hasGivenInput = true

func _handle_extra_input() -> void:
	# Check for confirming menu option
	var isConfirmed : bool = Input.get_action_strength("confirm")
	if isConfirmed:
		var selected = $Buttons.get_children().filter(func(button): return button.isSelected)[0]
		hasGivenInput = true
		match String(selected.name):
			"Continue":
				hide()
				get_tree().paused = false
			"RetryStage":
				get_tree().paused = false
				get_node("/root/Game").restart_game()
			"Filler":
				print("Filler chosen")
			"MainMenu":
				get_tree().paused = false
				get_node("/root/Game").main_menu()
		return
	
	var isEscape : bool = Input.get_action_strength("escape")
	if isEscape:
		hasGivenInput = true
		hide()
		get_tree().paused = false
