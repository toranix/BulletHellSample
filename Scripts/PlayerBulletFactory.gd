extends BulletFactory
class_name PlayerBulletFactory

const BULLET_CAPACITY := 500

var bullet_shapes : Array = PlayerBullet.REGIONS.map(
	func(rect):
		var shp = CircleShape2D.new()
		shp.set_radius(min(rect.size.x,rect.size.y)*0.5)
		return shp
)

func _on_ready() -> void:
	Global.player_bullet_factory = self
	bullet = preload("res://Objects/PlayerBullet.tscn")
	bullet_capacity = BULLET_CAPACITY

func spawn_bullet(posn, angle, type) -> PlayerBullet:
	var b = get_bullet()
	if b: b.init_bullet(posn, wrapf(angle, 0, 2*PI), type)
	return b
