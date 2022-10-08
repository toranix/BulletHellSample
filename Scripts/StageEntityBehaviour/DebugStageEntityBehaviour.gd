extends Behaviour

func run_behaviour() -> void:
	run_movement()
	
	var ring_size = 6
	while true:
		await wait(60)
		var offset = randf()*2*PI/ring_size
		var bullet_type = randi()%21
		for i in ring_size:
			Global.enemy_bullet_factory.spawn(
				obj.position,
				i*2*PI/ring_size + offset,
				3.5,
				bullet_type
			)

func run_movement() -> void:
	while true:
		await wait(1)
		if randf() < 0.015:
			obj.set_angle(randf()*2*PI)
