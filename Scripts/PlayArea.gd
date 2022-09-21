extends Control

func _ready() -> void:
	position = (GlobalConstants.WINDOW_SIZE - GlobalConstants.PLAY_AREA_SIZE) / 2
	size = GlobalConstants.PLAY_AREA_SIZE
