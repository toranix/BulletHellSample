extends Bullet
class_name PlayerBullet

enum TYPE {REIMU_BASIC, REIMU_HOMING}

const SPEEDS := [15.0, 18.0]
const DAMAGE := [10.0, 6.0]
const REGIONS := [
	Rect2(16, 160, 16, 16),
	Rect2(16, 208, 64, 64),
]

# Sets data for "spawning" a "new" bullet
func init_bullet(posn, init_angle, init_type) -> void:
	_init_bullet(posn, init_angle, SPEEDS[init_type])

	# Sprite Properties
	type = init_type
	region_rect = REGIONS[type]
	modulate.a = 0.25

func _handle_animation() -> void:
	match type:
		TYPE.REIMU_HOMING:
			rotation += PI / 15

func _handle_border_culling() -> void:
	if (lifetime >= CULLING_THRESHOLD):
		if (!Global.player_bullet_factory.bounding_box.has_point(position)):
			queue_despawn()
			return

func _handle_collision() -> void:
	# Check collision with Enemies
	query.transform = global_transform
	var result := direct_space_state.intersect_shape(query, 1)
	if result.size() > 0 && result[0].collider is StageEntity:
		result[0].collider.take_damage(DAMAGE[type])
		set_angle(randf()*2*PI)
		queue_despawn()
		return
		
func _handle_movement() -> void:
	match type:
		TYPE.REIMU_HOMING:
			if get_parent().get_parent().get_node("StageEntity").freed:
				speed = min(SPEEDS[TYPE.REIMU_HOMING], speed * 1.15)
				continue
			var angle_to_point = position.angle_to_point(Global.debug_homing_position)
			var difference = angle_to_point - angle
			if difference > PI:
				difference = 2*PI - difference
			elif difference < -PI:
				difference = 2*PI + difference
			if (abs(difference) > deg_to_rad(30) &&
				abs(difference) < deg_to_rad(150) &&
				position.distance_squared_to(Global.debug_homing_position) <= pow(150, 2)):
				speed = max(SPEEDS[TYPE.REIMU_HOMING]*0.2, speed * 0.9)
			else:
				speed = min(SPEEDS[TYPE.REIMU_HOMING], speed * 1.15)
			set_angle(angle + difference * 0.1, false)
			continue
		_:
			position += direction * speed
