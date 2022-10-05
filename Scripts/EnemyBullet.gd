extends Bullet
class_name EnemyBullet

#enum COLOUR {RED, ORANGE, YELLOW, GREEN, BLUE, PURPLE, PINK}
enum TYPE {
	# MEDIUM_ROUND
	MEDIUM_ROUND_RED,
	MEDIUM_ROUND_ORANGE,
	MEDIUM_ROUND_YELLOW,
	MEDIUM_ROUND_GREEN,
	MEDIUM_ROUND_BLUE,
	MEDIUM_ROUND_PURPLE,
	MEDIUM_ROUND_PINK,
	
	# SMALL_ROUND
	SMALL_ROUND_RED,
	SMALL_ROUND_ORANGE,
	SMALL_ROUND_YELLOW,
	SMALL_ROUND_GREEN,
	SMALL_ROUND_BLUE,
	SMALL_ROUND_PURPLE,
	SMALL_ROUND_PINK,
	
	# SMALL_ARROWHEAD
	SMALL_ARROWHEAD_RED,
	SMALL_ARROWHEAD_ORANGE,
	SMALL_ARROWHEAD_YELLOW,
	SMALL_ARROWHEAD_GREEN,
	SMALL_ARROWHEAD_BLUE,
	SMALL_ARROWHEAD_PURPLE,
	SMALL_ARROWHEAD_PINK
}

const REGIONS : Array = [
	# MEDIUM_ROUND
	Rect2(0, 0, 32, 32),
	Rect2(32, 0, 32, 32),
	Rect2(64, 0, 32, 32),
	Rect2(96, 0, 32, 32),
	Rect2(128, 0, 32, 32),
	Rect2(160, 0, 32, 32),
	Rect2(192, 0, 32, 32),
	
	# SMALL_ROUND
	Rect2(0, 32, 16, 16),
	Rect2(16, 32, 16, 16),
	Rect2(32, 32, 16, 16),
	Rect2(48, 32, 16, 16),
	Rect2(64, 32, 16, 16),
	Rect2(80, 32, 16, 16),
	Rect2(96, 32, 16, 16),
	
	# SMALL_ARROWHEAD
	Rect2(112, 32, 16, 16),
	Rect2(128, 32, 16, 16),
	Rect2(144, 32, 16, 16),
	Rect2(160, 32, 16, 16),
	Rect2(176, 32, 16, 16),
	Rect2(192, 32, 16, 16),
	Rect2(208, 32, 16, 16)
]

# Sets data for "spawning" a "new" bullet
func init_bullet(posn, init_angle, init_speed, init_type) -> void:
	_init_bullet(posn, init_angle, init_speed)

	# Sprite Properties
	type = init_type
	region_rect = REGIONS[type]
	modulate.a = 1.0
	
func _handle_border_culling() -> void:
	if (lifetime >= CULLING_THRESHOLD):
		if (!Global.enemy_bullet_factory.bounding_box.has_point(position)):
			queue_despawn()
			return

func _handle_collision() -> void:
	# Check collision with Player
	query.transform = global_transform
	var result := direct_space_state.intersect_shape(query, 1)
	if result.size() > 0 && result[0].collider is Player:
		Global.player.on_hit()
		queue_despawn()
		return
