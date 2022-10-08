extends Behaviour

var behaviour = preload("res://Scripts/StageEntityBehaviour/DebugStageEntityBehaviour.gd")

func run_behaviour() -> void:
#	while true:
#		if Global.debug.is_debug:
#			_debug_spawn_entities()
#		await wait(70)
	await run_segment_01()
	Global.stage_entity_factory.clear_active()
	await run_segment_02()
	Global.stage_entity_factory.clear_active()
	await run_segment_03()
	Global.stage_entity_factory.clear_active()
	Global.debug.dprint("Debug stage complete")

# Spawns 10 enemies in a row moving across the screen
func run_segment_01() -> void:
	for i in 10:
		await wait(60)
		Global.stage_entity_factory.spawn(
			Vector2(Global.PLAY_AREA_SIZE.x + 50, 200),
			PI,
			1.5,
			StageEntity.TYPE.FAIRY_BLUE,
			200,
			0.2,
			null
		)
	await wait_segment_end(300)

# Spawns 3 rows of 5 enemies moving across the screen
func run_segment_02() -> void:
	for j in 3:
		segment_02_spawn_row(j % 2 == 1, j * 100)
		await wait(70)
	await wait_segment_end(900)

func segment_02_spawn_row(right : bool, offset : float) -> void:
	for i in 5:
		await wait(60)
		Global.stage_entity_factory.spawn(
			Vector2((Global.PLAY_AREA_SIZE.x + 50) if right else -50, 200 + offset),
			PI if right else 0,
			1.5,
			StageEntity.TYPE.FAIRY_BLUE,
			50,
			0.5,
			null
		)

# Spawns 10 enemies that dart around the upper screen
# randomly and shoot rings of bullets
func run_segment_03() -> void:
	var spawn_box = Vector2(100,150)
	for i in 10:
		await wait(70)
		Global.stage_entity_factory.spawn(
			Vector2(randi()%int(spawn_box.x) + (Global.PLAY_AREA_SIZE.x - spawn_box.x)/2,
				randi()%int(spawn_box.y) + (Global.PLAY_AREA_SIZE.y - spawn_box.y)/2),
			randf()*2*PI,
			randf()*2.0 + 1.5,
			StageEntity.TYPE.FAIRY_BLUE,
			500,
			0.1,
			behaviour
		)
	await wait_segment_end(900)

func _debug_spawn_entities() -> void:
	var to_spawn = 5
	var spawn_box = Vector2(100,150)
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
