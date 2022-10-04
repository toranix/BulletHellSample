extends Control

func _ready() -> void:
	position = (Global.WINDOW_SIZE - Global.PLAY_AREA_SIZE) / 2
	size = Global.PLAY_AREA_SIZE
