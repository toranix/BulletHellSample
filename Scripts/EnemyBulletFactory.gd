extends EntityFactory
class_name EnemyBulletFactory

const BULLET_CAPACITY := 3000
const BULLET_PADDING := 50

var bullet_shapes : Array = EnemyBullet.REGIONS.map(
	func(rect : Rect2):
		var shp = CircleShape2D.new()
		shp.set_radius(min(rect.size.x, rect.size.y)*0.3)
		return shp
)

func _on_ready() -> void:
	Global.enemy_bullet_factory = self
	entity = preload("res://Objects/EnemyBullet.tscn")
	entity_capacity = BULLET_CAPACITY
	entity_padding = BULLET_PADDING

func spawn(posn, angle, init_speed, type) -> EnemyBullet:
	var b = get_entity()
	if b: b.init_bullet(posn, wrapf(angle, 0, 2*PI), init_speed, type)
	return b
