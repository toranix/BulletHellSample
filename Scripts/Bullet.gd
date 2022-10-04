extends Sprite2D
class_name Bullet

enum OWNERS {ENEMY, PLAYER}
enum COLOUR {RED, ORANGE, YELLOW, GREEN, BLUE, PURPLE, PINK}
enum TYPE_ENEMY {MEDIUM_ROUND, SMALL_ROUND, SMALL_ARROWHEAD}
enum TYPE_PLAYER {REIMU_BASIC}

const HITBOXES := [11.5, 5.5, 4.0]
const REGIONS : Array = [
	Rect2(0, 0, 224, 32),
	Rect2(0, 32, 112, 16),
	Rect2(112, 32, 112, 16)
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
var directSpaceState : PhysicsDirectSpaceState2D
var bulletOwner : OWNERS
var lifetime : float
var isQueuedForDespawn : bool

# Basic initialization
func _ready() -> void:
	directSpaceState = get_world_2d().direct_space_state
	query.collide_with_bodies = true
	query.collision_mask = 1
	freed = true
	isQueuedForDespawn = false
	$DespawnTimer.wait_time = DESPAWN_DELAY
	hide()
	set_process(false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta) -> void:
	# Fade out bullet and do nothing else if queued for despawning
	if isQueuedForDespawn:
		modulate.a = max(modulate.a - 0.1, 0.0)
		return
	
	# Move Bullet
	position += direction * speed
	lifetime += delta
	
	# Border culling
	if (lifetime >= CULLING_THRESHOLD):
		if (!GlobalVariables.bulletFactory.boundingBox.has_point(position)):
			queue_despawn()
			return

	# Check collision with Player
	query.transform = global_transform
	var result := directSpaceState.intersect_shape(query, 1)
	if result:
		GlobalVariables.player.on_hit()
		queue_despawn()
		return

# Called when bullet is to be despawned (either destroyed on screen or has left the screen)
func queue_despawn() -> void:
	isQueuedForDespawn = true
	$DespawnTimer.start()

# Sets data for "spawning" a "new" bullet
func init_bullet(posn, initAngle, initSpeed, initType, initColour, initOwner) -> void:
	# Physics Properties
	position = posn
	angle = deg_to_rad(initAngle)
	speed = initSpeed
	direction = Vector2.RIGHT.rotated(angle)
	shape = GlobalVariables.bulletFactory.bulletShapes[type]
	query.set_shape(shape)

	# Sprite Properties
	type = initType
	colour = initColour
	rotation = angle + PI / 2
	frame = colour
	region_rect = REGIONS[type]
	modulate.a = 1.0
	
	# Entity Properties and misc
	bulletOwner = initOwner
	freed = false
	isQueuedForDespawn = false
	lifetime = 0
	GlobalVariables.activeBulletCount += 1
	show()
	set_process(true)

# Deactivates the bullet to save on resources without deallocating it
func despawn_bullet() -> void:
	freed = true
	isQueuedForDespawn = false
	GlobalVariables.activeBulletCount -= 1
	hide()
	set_process(false)

func _on_despawn_timer_timeout():
	despawn_bullet()
