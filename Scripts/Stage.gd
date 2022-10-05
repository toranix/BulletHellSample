extends Control

var frame : int = 0
var is_escape_previous_frame : bool

func _ready():
	randomize()
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
	
	frame += 1
	_debug_enemy_shoot()
	_debug_homing()

func _debug_enemy_shoot() -> void:
	var split : int = 2
	if (frame % 2 == 0):
		for n in split:
			Global.enemy_bullet_factory.spawn_bullet(
				Global.PLAY_AREA_SIZE / 2,
				deg_to_rad(frame * 17 + (n * 360 / split)),
				1.5,
				randi()%21)

func _debug_homing() -> void:
	if (frame % 120 == 0):
		Global.debug_homing_position = Vector2(randi()%400+100, randi()%500+85)
		print("Debug homing target: %s" % Global.debug_homing_position)
	return
