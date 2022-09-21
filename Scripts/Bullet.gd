extends Sprite2D
class_name Bullet

const BULLET_REGIONS : Array = [
	Rect2(0, 0, 224, 32),
	Rect2(0, 32, 112, 16)
]
const CULLING_THRESHOLD : float = 0
const DESPAWN_DELAY : float = 0.15

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
var is_queued_for_despawn : bool

func _ready() -> void:
	direct_space_state = get_world_2d().direct_space_state
	query.collide_with_bodies = true
	query.collision_mask = 1
	freed = true
	is_queued_for_despawn = false
	$DespawnTimer.wait_time = DESPAWN_DELAY
	hide()
	set_process(false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta) -> void:
	# Fade out bullet and do nothing else if queued for despawning
	if is_queued_for_despawn:
		modulate.a = max(modulate.a - 0.1, 0.0)
		return
	
	# Move Bullet
	position += direction * speed
	lifetime += delta
	
	# Border culling
	if (lifetime >= CULLING_THRESHOLD):
		if (!GlobalVariables.bullet_factory.bounding_box.has_point(position)):
			queue_despawn()
			return

	# Check collision with Player
	query.transform = global_transform
	var result := direct_space_state.intersect_shape(query, 1)
	if result:
		GlobalVariables.player.on_hit()
		queue_despawn()
		return
		
func queue_despawn() -> void:
	is_queued_for_despawn = true
	$DespawnTimer.start()

func init_bullet(posn, init_angle, init_speed, init_type, init_colour) -> void:
	position = posn
	angle = deg_to_rad(init_angle)
	speed = init_speed
	type = init_type
	colour = init_colour
	direction = Vector2.RIGHT.rotated(angle)
	rotation = angle
	frame = colour
	region_rect = BULLET_REGIONS[type]
	freed = false
	is_queued_for_despawn = false
	modulate.a = 1.0
	shape = GlobalVariables.bullet_factory.bullet_shapes[type]
	lifetime = 0
	query.set_shape(shape)
	GlobalVariables.active_bullet_count += 1
	show()
	set_process(true)

func despawn_bullet() -> void:
	freed = true
	is_queued_for_despawn = false
	GlobalVariables.active_bullet_count -= 1
	hide()
	set_process(false)


func _on_despawn_timer_timeout():
	despawn_bullet()
