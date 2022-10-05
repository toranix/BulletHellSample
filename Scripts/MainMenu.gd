extends Menu

func _handle_confirm() -> void:
	var selected = $Buttons.get_children().filter(func(button): return button.is_selected)[0]
	match String(selected.name):
		"StartGame":
			get_node("/root/Game").start_game()
		"Filler":
			Global.debug.dprint("Filler chosen")
		"Exit":
			get_tree().quit()
