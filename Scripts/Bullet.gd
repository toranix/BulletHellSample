extends Sprite2D
class_name Bullet

const CULLING_THRESHOLD : float = 0
const DESPAWN_DELAY : float = 0.15

@export var angle : float
@export var speed : float
@export var type : int
var direction : Vector2
var freed : bool
var shape : Shape2D
var query := PhysicsShapeQueryParameters2D.new()
var direct_space_state : PhysicsDirectSpaceState2D
var lifetime : float
var is_queued_for_despawn : bool

# Basic initialization
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
		modulate.a = max(modulate.a * 0.9, 0.0)
		return
		
	lifetime += delta
	
	_handle_movement()
	_handle_animation()
	_handle_border_culling()
	_handle_collision()

func _handle_animation() -> void:
	pass

func _handle_border_culling() -> void:
	pass

func _handle_collision() -> void:
	pass
	
func _handle_movement() -> void:
	position += direction * speed

# Called when bullet is to be despawned (either destroyed on screen or has left the screen)
func queue_despawn() -> void:
	is_queued_for_despawn = true
	$DespawnTimer.start()

func _init_bullet(posn, init_angle, init_speed) -> void:
	# Physics Properties
	position = posn
	speed = init_speed
	set_angle(init_angle)
	shape = Global.enemy_bullet_factory.bullet_shapes[type]
	query.set_shape(shape)
	
	# Entity Properties and misc
	freed = false
	is_queued_for_despawn = false
	lifetime = 0
	Global.active_bullet_count += 1
	show()
	set_process(true)
	
func set_angle(new_angle : float, update_rotation : bool = true) -> void:
	angle = wrapf(new_angle, 0, 2*PI)
	rotation = angle if update_rotation else rotation
	direction = Vector2.RIGHT.rotated(angle)

# Deactivates the bullet to save on resources without deallocating it
func despawn_bullet() -> void:
	freed = true
	is_queued_for_despawn = false
	Global.active_bullet_count -= 1
	hide()
	set_process(false)

func _on_despawn_timer_timeout():
	despawn_bullet()
