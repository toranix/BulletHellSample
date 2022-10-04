extends Menu

func _handle_extra_input() -> void:
	# Check for confirming menu option
	var isConfirmed : bool = Input.get_action_strength("confirm")
	if isConfirmed:
		var selected = $Buttons.get_children().filter(func(button): return button.isSelected)[0]
		hasGivenInput = true
		match String(selected.name):
			"StartGame":
				get_node("/root/Game").start_game()
			"Filler":
				print("Filler chosen")
			"Exit":
				get_tree().quit()
