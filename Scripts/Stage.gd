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
		Global.debug.dprint("paused")
		$PauseMenu.select_button(0)
		$PauseMenu.show()
		get_tree().paused = true
	is_escape_previous_frame = is_escape
	
	frame += 1
	
	if Global.debug.is_debug:
		_debug_spawn_entities()
#		_debug_enemy_shoot()

func _debug_spawn_entities() -> void:
	var to_spawn = 10
	if Global.stage_entity_factory.get_active_count() < to_spawn:
		Global.stage_entity_factory.spawn(
			Vector2(randi()%200+200,randi()%200+235),
			randf()*2*PI,
			1.5,
			StageEntity.TYPE.FAIRY_BLUE,
			100,
			0)
	for obj in Global.stage_entity_factory.get_children():
		if !obj.freed && randi()%100 == 0:
			obj.set_angle(randf()*2*PI)

func _debug_enemy_shoot() -> void:
	var split : int = 2
	if (frame % 2 == 0):
		for n in split:
			Global.enemy_bullet_factory.spawn(
				Global.PLAY_AREA_SIZE / 2,
				deg_to_rad(frame * 17 + (n * 360 / split)),
				1.5,
				randi()%21)
