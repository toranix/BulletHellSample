extends Node2D
class_name BulletFactory

const BULLET_PADDING : float = 50

var bounding_box : Rect2
var bullet
var bullet_capacity : int

func _ready():
	bounding_box = Rect2(
		- BULLET_PADDING,
		- BULLET_PADDING,
		Global.PLAY_AREA_SIZE.x + 2 * BULLET_PADDING,
		Global.PLAY_AREA_SIZE.y + 2 * BULLET_PADDING
	)
	
	_on_ready()
	
	# Pre-instantiating all the bullets the game will use and caches it for the
	# rest of runtime
	for n in bullet_capacity:
		add_child(bullet.instantiate())
		
func _on_ready() -> void:
	pass

# Finds and returns the first inactive bullet in the pool of cached bullets, or
# null if the game is at capacity
func get_bullet() -> Bullet:
	for b in get_children():
		if b.freed: return b
	return null
