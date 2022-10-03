extends Label

var isSelected : bool = false

func get_class() -> String: return "MenuButton"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	text = text.strip_edges()
	if isSelected:
		text = "  " + text
