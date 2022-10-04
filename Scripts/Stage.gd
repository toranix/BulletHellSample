extends Control

var isEscapePreviousFrame : bool
var frame : int = 0
var split : int = 3

func _ready():
	$PauseMenu.hide()
	isEscapePreviousFrame = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var isEscape : bool = Input.get_action_strength("escape")
	if (isEscape && !isEscapePreviousFrame):
		print("pause")
		$PauseMenu.select_button(0)
		$PauseMenu.show()
		get_tree().paused = true
	isEscapePreviousFrame = isEscape
	
#	_debug_enemy_shoot()

func _debug_enemy_shoot() -> void:
	frame += 1
	if (frame % 2 == 0):
		for n in split:
			GlobalVariables.bulletFactory.spawn_enemy_bullet(
				GlobalConstants.PLAY_AREA_SIZE / 2,
				frame * 17 + (n * 360 / split),
				1.5,
				Bullet.TYPE_ENEMY.SMALL_ROUND,
				(frame / 9) % Bullet.COLOUR.size())
