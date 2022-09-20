extends Sprite2D
class_name Bullet

@export var speed : float
@export var angle : float
@export var colour : int
@export var type : int
var direction : Vector2
var freed : bool
var bounding_box : Rect2
var shape : Shape2D

func get_class(): return "Bullet"
func is_class(cls): return cls == "Bullet"

func _ready() -> void:
	bounding_box = Rect2(
		- GlobalConstants.BULLET_PADDING,
		- GlobalConstants.BULLET_PADDING,
		GlobalConstants.PLAY_AREA_SIZE.x + 2 * GlobalConstants.BULLET_PADDING,
		GlobalConstants.PLAY_AREA_SIZE.y + 2 * GlobalConstants.BULLET_PADDING
	)
	freed = true
	shape = CircleShape2D.new()
	hide()
	set_process(false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta) -> void:
	position += direction * speed
	
	if (!bounding_box.has_point(position)):
		free_bullet()
		return
	
	# Check collision with Player
	var query := PhysicsShapeQueryParameters2D.new()
	query.set_shape(shape)
	query.collide_with_bodies = true
	query.collision_mask = 1
	query.transform = global_transform
	
	var result := get_world_2d().direct_space_state.intersect_shape(query, 1)
	if result:
		GlobalVariables.player.on_hit()
		free_bullet()
		return

func init_bullet(posn, init_angle, init_speed, init_type, init_colour) -> void:
	position = posn
	angle = init_angle
	speed = init_speed
	type = init_type
	colour = init_colour
	direction = Vector2(1,0).rotated(angle)
	frame = colour
	freed = false
	shape = CircleShape2D.new()
	shape.radius = 10.0
	GlobalVariables.active_bullet_count += 1
	show()
	set_process(true)

func free_bullet() -> void:
	freed = true
	shape.call_deferred("free")
	GlobalVariables.active_bullet_count -= 1
	hide()
	set_process(false)
