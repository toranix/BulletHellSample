extends Menu

func _handle_extra_input() -> void:
	# Check for confirming menu option
	var is_confirmed : bool = Input.get_action_strength("confirm")
	if is_confirmed:
		var selected = $Buttons.get_children().filter(func(button): return button.is_selected)[0]
		has_given_input = true
		match String(selected.name):
			"StartGame":
				get_node("/root/Game").start_game()
			"Filler":
				print("Filler chosen")
			"Exit":
				get_tree().quit()
