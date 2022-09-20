extends Node2D

const BULLET_CAPACITY : int = 5000
const BULLET_HITBOXES := [13.5]
const BULLET_PADDING : float = 50

enum COLOUR {RED, ORANGE, YELLOW, GREEN, BLUE, PURPLE, PINK}
enum BULLET_TYPE {MEDIUM_ROUND}

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
	for n in BULLET_CAPACITY:
		add_child(bullet.instantiate())

func get_bullet() -> Bullet:
	for b in get_children():
		if b.freed: return b
	return null

func spawn_bullet(posn, angle, init_speed, type, colour) -> void:
	var b = get_bullet()
	if b: b.init_bullet(posn, angle, init_speed, type, colour)
