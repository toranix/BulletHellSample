extends Node2D
class_name EntityFactory

var bounding_box : Rect2
var entity
var entity_capacity : int
var entity_padding : float

func _ready():
	_on_ready()
	
	bounding_box = Rect2(
		- entity_padding,
		- entity_padding,
		Global.PLAY_AREA_SIZE.x + 2 * entity_padding,
		Global.PLAY_AREA_SIZE.y + 2 * entity_padding
	)
	
	# Pre-instantiating all the bullets the game will use and caches it for the
	# rest of runtime
	for n in entity_capacity:
		add_child(entity.instantiate())
		
func _on_ready() -> void:
	pass

# Finds and returns the first inactive bullet in the pool of cached bullets, or
# null if the game is at capacity
func get_entity():
	for obj in get_children():
		if obj.freed: return obj
	return null

func get_active_count() -> int:
	var count = 0
	for obj in get_children():
		if !obj.freed: count += 1
	return count

func clear_active() -> void:
	pass
