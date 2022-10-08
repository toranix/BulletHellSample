extends Menu

func _on_ready() -> void:
	inputs += ["escape"]

func _handle_confirm() -> void:
	var selected = $Buttons.get_children().filter(func(button): return button.is_selected)[0]
	match String(selected.name):
		"Continue":
			resume()
		"RetryStage":
			get_tree().paused = false
			get_node("/root/Game").restart_game()
		"Filler":
			Global.debug.dprint("Filler chosen")
		"MainMenu":
			get_tree().paused = false
			get_node("/root/Game").main_menu()

func _handle_extra_input(current_frame_inputs) -> void:
	if current_frame_inputs["escape"] && !previous_frame_inputs["escape"]:
		resume()

func resume() -> void:
	hide()
	Global.debug.dprint("unpaused")
	get_tree().paused = false

func _on_pause_menu_visibility_changed():
	init_all_inputs()
