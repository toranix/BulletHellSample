extends Bullet
class_name PlayerBullet

enum TYPE {REIMU_BASIC}

const HITBOXES := [8.0]
const REGIONS := [
	Rect2(16, 160, 16, 16)
]

# Sets data for "spawning" a "new" bullet
func init_bullet(posn, init_angle, init_speed, init_type) -> void:
	_init_bullet(posn, init_angle, init_speed)

	# Sprite Properties
	type = init_type
	rotation = angle
	region_rect = REGIONS[type]
	modulate.a = 0.4
	
func _handle_border_culling() -> void:
	if (lifetime >= CULLING_THRESHOLD):
		if (!Global.player_bullet_factory.bounding_box.has_point(position)):
			queue_despawn()
			return

func _handle_collision() -> void:
	return
	# Check collision with Enemies
	query.transform = global_transform
	var result := direct_space_state.intersect_shape(query, 1)
	if result.size() > 0 && !(result[0].collider is Player):
		queue_despawn()
		return
