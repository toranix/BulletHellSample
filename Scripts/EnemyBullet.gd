extends Bullet
class_name EnemyBullet

enum COLOUR {RED, ORANGE, YELLOW, GREEN, BLUE, PURPLE, PINK}
enum TYPE {MEDIUM_ROUND, SMALL_ROUND, SMALL_ARROWHEAD}

const HITBOXES := [11.5, 5.5, 4.0]
const REGIONS : Array = [
	Rect2(0, 0, 224, 32),
	Rect2(0, 32, 112, 16),
	Rect2(112, 32, 112, 16)
]

@export var colour : int

# Sets data for "spawning" a "new" bullet
func init_bullet(posn, init_angle, init_speed, init_type, init_colour) -> void:
	_init_bullet(posn, init_angle, init_speed)

	# Sprite Properties
	type = init_type
	colour = init_colour
	rotation = angle + PI / 2
	frame = colour
	region_rect = REGIONS[type]
	modulate.a = 1.0

func _handle_collision() -> void:
	# Check collision with Player
	query.transform = global_transform
	var result := direct_space_state.intersect_shape(query, 1)
	if result:
		Global.player.on_hit()
		queue_despawn()
		return
