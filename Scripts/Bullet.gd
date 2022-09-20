extends Sprite2D
class_name Bullet

const CULLING_THRESHOLD : float = 15

@export var speed : float
@export var angle : float
@export var colour : int
@export var type : int
var direction : Vector2
var freed : bool
var shape : Shape2D
var query := PhysicsShapeQueryParameters2D.new()
var direct_space_state : PhysicsDirectSpaceState2D
var lifetime : float

func _ready() -> void:
	direct_space_state = get_world_2d().direct_space_state
	query.collide_with_bodies = true
	query.collision_mask = 1
	freed = true
	hide()
	set_process(false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta) -> void:
	# Move Bullet
	position += direction * speed
	lifetime += delta
	
	# Border culling
	if (lifetime >= CULLING_THRESHOLD):
		if (!GlobalVariables.bullet_factory.bounding_box.has_point(position)):
			free_bullet()
			return		
	
	# Check collision with Player
	query.transform = global_transform
	var result := direct_space_state.intersect_shape(query, 1)
	if result:
		GlobalVariables.player.on_hit()
		free_bullet()
		return

func init_bullet(posn, init_angle, init_speed, init_type, init_colour) -> void:
	position = posn
	angle = deg_to_rad(init_angle)
	speed = init_speed
	type = init_type
	colour = init_colour
	direction = Vector2(1,0).rotated(angle)
	rotation = angle
	frame = colour
	freed = false
	shape = GlobalVariables.bullet_factory.bullet_shapes[type]
	lifetime = 0
	query.set_shape(shape)
	GlobalVariables.active_bullet_count += 1
	show()
	set_process(true)

func free_bullet() -> void:
	freed = true
	GlobalVariables.active_bullet_count -= 1
	hide()
	set_process(false)
