extends Menu

func _ready() -> void:
	inputs = ["down", "up", "confirm", "escape"]
	has_given_input = true

func _handle_extra_input() -> void:
	# Check for confirming menu option
	var is_confirmed : bool = Input.get_action_strength("confirm")
	if is_confirmed:
		var selected = $Buttons.get_children().filter(func(button): return button.is_selected)[0]
		has_given_input = true
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
	
	var is_escape : bool = Input.get_action_strength("escape")
	if is_escape:
		has_given_input = true
		hide()
		get_tree().paused = false
