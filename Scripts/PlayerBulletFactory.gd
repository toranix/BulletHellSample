extends BulletFactory
class_name PlayerBulletFactory

const BULLET_CAPACITY := 500

var bullet_shapes : Array = PlayerBullet.HITBOXES.map(
	func(r):
		var shp = CircleShape2D.new()
		shp.set_radius(r)
		return shp
)

func _on_ready() -> void:
	Global.player_bullet_factory = self
	bullet = preload("res://Objects/PlayerBullet.tscn")
	bullet_capacity = BULLET_CAPACITY

func spawn_bullet(posn, angle, init_speed, type) -> void:
	var b = get_bullet()
	if b: b.init_bullet(posn, angle, init_speed, type)
