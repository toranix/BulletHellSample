extends Behaviour

var homing_target = Vector2.ZERO

func run_behaviour() -> void:
	run_movement()
	
	var ring_size = 6
	await wait(30)
	while true:
		var offset = randf()*2*PI/ring_size
		var bullet_type = randi()%21
		for i in ring_size:
			Global.enemy_bullet_factory.spawn(
				obj.position,
				i*2*PI/ring_size + offset,
				3.5,
				bullet_type
			)
		await wait(60)

func run_movement() -> void:
	update_movement()
	while true:
		homing_target = Global.PLAY_AREA_SIZE * Vector2(randf(),randf())
		await wait(90)

func update_movement() -> void:
	while true:
		var angle_to_point = obj.position.angle_to_point(homing_target)
		var distance_to_point = obj.position.distance_to(homing_target)
		obj.set_angle(angle_to_point)
		obj.speed = distance_to_point * 0.05
		await wait(1)
