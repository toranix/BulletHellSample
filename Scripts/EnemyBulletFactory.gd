extends BulletFactory
class_name EnemyBulletFactory

const BULLET_CAPACITY := 5000

var bullet_shapes : Array = EnemyBullet.REGIONS.map(
	func(rect : Rect2):
		var shp = CircleShape2D.new()
		shp.set_radius(min(rect.size.x, rect.size.y)*0.3)
		return shp
)

func _on_ready() -> void:
	Global.enemy_bullet_factory = self
	bullet = preload("res://Objects/EnemyBullet.tscn")
	bullet_capacity = BULLET_CAPACITY

func spawn_bullet(posn, angle, init_speed, type) -> EnemyBullet:
	var b = get_bullet()
	if b: b.init_bullet(posn, wrapf(angle, 0, 2*PI), init_speed, type)
	return b
