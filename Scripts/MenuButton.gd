extends Label

var is_selected : bool = false

func get_class() -> String: return "MenuButton"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	text = text.strip_edges()
	if is_selected:
		text = "  " + text
