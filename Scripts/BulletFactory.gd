extends Node2D
class_name BulletFactory

const BULLET_CAPACITY : int = 5000
const BULLET_PADDING : float = 50

var bounding_box : Rect2
var bullet = preload("res://Objects/Bullet.tscn")
var bullet_shapes : Array = Bullet.HITBOXES.map(
	func(r):
		var shp = CircleShape2D.new()
		shp.set_radius(r)
		return shp
)

func _ready():
	Global.bullet_factory = self
	bounding_box = Rect2(
		- BULLET_PADDING,
		- BULLET_PADDING,
		Global.PLAY_AREA_SIZE.x + 2 * BULLET_PADDING,
		Global.PLAY_AREA_SIZE.y + 2 * BULLET_PADDING
	)
	
	# Pre-instantiating all the bullets the game will use and caches it for the
	# rest of runtime
	for n in BULLET_CAPACITY:
		add_child(bullet.instantiate())

# Finds and returns the first inactive bullet in the pool of cached bullets, or
# null if the game is at capacity
func get_bullet() -> Bullet:
	for b in get_children():
		if b.freed: return b
	return null
	
func spawn_enemy_bullet(posn, angle, init_speed, type, colour) -> void:
	_spawn_bullet(posn, angle, init_speed, type, colour, Bullet.OWNERS.ENEMY)

func spawn_player_bullet(posn, angle, init_speed, type) -> void:
	_spawn_bullet(posn, angle, init_speed, type, 0, Bullet.OWNERS.PLAYER)
# Tries to get and activate an inactive bullet
func _spawn_bullet(posn, angle, init_speed, type, colour, bullet_owner) -> void:
	var b = get_bullet()
	if b: b.init_bullet(posn, wrapf(angle, 0, 360), init_speed, type, colour, bullet_owner)
