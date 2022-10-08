extends Behaviour

var behaviour = preload("res://Scripts/StageEntityBehaviour/DebugStageEntityBehaviour.gd")

func run_behaviour() -> void:
	while true:
		if Global.debug.is_debug:
			_debug_spawn_entities()
		await wait(70)

func _debug_spawn_entities() -> void:
	var to_spawn = 5
	var spawn_box = Vector2(400,450)
	if Global.stage_entity_factory.get_active_count() < to_spawn:
		Global.stage_entity_factory.spawn(
			Vector2(randi()%int(spawn_box.x) + (Global.PLAY_AREA_SIZE.x - spawn_box.x)/2,
				randi()%int(spawn_box.y) + (Global.PLAY_AREA_SIZE.y - spawn_box.y)/2),
			randf()*2*PI,
			randf()*2.0 + 1.5,
			StageEntity.TYPE.FAIRY_BLUE,
			500,
			0,
			behaviour
		)
