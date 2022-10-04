extends Control

var is_escape_previous_frame : bool
var frame : int = 0
var split : int = 3

func _ready():
	$PauseMenu.hide()
	is_escape_previous_frame = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var is_escape : bool = Input.get_action_strength("escape")
	if (is_escape && !is_escape_previous_frame):
		print("pause")
		$PauseMenu.select_button(0)
		$PauseMenu.show()
		get_tree().paused = true
	is_escape_previous_frame = is_escape
	
	_debug_enemy_shoot()

func _debug_enemy_shoot() -> void:
	frame += 1
	if (frame % 2 == 0):
		for n in split:
			Global.bullet_factory.spawn_enemy_bullet(
				Global.PLAY_AREA_SIZE / 2,
				frame * 17 + (n * 360 / split),
				1.5,
				Bullet.TYPE_ENEMY.SMALL_ROUND,
				(frame / 9) % Bullet.COLOUR.size())
