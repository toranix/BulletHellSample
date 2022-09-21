extends Node2D

const BULLET_CAPACITY : int = 5000
const BULLET_HITBOXES := [11.5, 5.5, 4.0]
const BULLET_PADDING : float = 50

enum COLOUR {RED, ORANGE, YELLOW, GREEN, BLUE, PURPLE, PINK}
enum BULLET_TYPE {MEDIUM_ROUND, SMALL_ROUND, SMALL_ARROWHEAD}

var bounding_box : Rect2
var bullet = preload("res://Objects/Bullet.tscn")
var bullet_shapes : Array = BULLET_HITBOXES.map(
	func(r):
		var shp = CircleShape2D.new()
		shp.set_radius(r)
		return shp
)

func _ready():
	GlobalVariables.bullet_factory = self
	bounding_box = Rect2(
		- BULLET_PADDING,
		- BULLET_PADDING,
		GlobalConstants.PLAY_AREA_SIZE.x + 2 * BULLET_PADDING,
		GlobalConstants.PLAY_AREA_SIZE.y + 2 * BULLET_PADDING
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

# Tries to get and activate an inactive bullet
func spawn_bullet(posn, angle, init_speed, type, colour) -> void:
	var b = get_bullet()
	if b: b.init_bullet(posn, wrapf(angle, 0, 360), init_speed, type, colour)
