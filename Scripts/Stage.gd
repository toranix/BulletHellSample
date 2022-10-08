extends Control

var frame : int = 0
var is_escape_previous_frame : bool
var behaviour = preload("res://Scripts/StageEntityBehaviour/DebugStageEntityBehaviour.gd")

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

func _debug_spawn_entities() -> void:
	var to_spawn = 20
	var spawn_box = Vector2(200,250)
	if Global.stage_entity_factory.get_active_count() < to_spawn:
		Global.stage_entity_factory.spawn(
			Vector2(randi()%int(spawn_box.x) + (Global.PLAY_AREA_SIZE.x - spawn_box.x)/2,
				randi()%int(spawn_box.y) + (Global.PLAY_AREA_SIZE.y - spawn_box.y)/2),
			randf()*2*PI,
			randf()*2.0 + 1.5,
			StageEntity.TYPE.FAIRY_BLUE,
			100,
			0,
			behaviour
		)
