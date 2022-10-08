extends CharacterBody2D
class_name StageEntity

enum DEATH_TYPE {EXPLODE_PRIZE, EXPLODE_EMPTY, OFF_SCREEN, BOSS}
enum TYPE {FAIRY_BLUE}

const DESPAWN_DELAY : float = 0.15

@export var angle : float
@export var max_health : float
@export var resist : float
@export var show_health : bool
@export var speed : float
@export var type : TYPE

var cur_health : float
var direction : Vector2
var freed : bool
var is_queued_for_despawn : bool
var state_machine : AnimationNodeStateMachinePlayback
var death_type : DEATH_TYPE
var lifetime : float = 0

func _ready() -> void:
	state_machine = $AnimationTree["parameters/playback"]
	$DespawnTimer.set_wait_time(DESPAWN_DELAY)
	set_tangible(false)
	$CollisionShape2d.shape.radius = 10.0
	freed = true
	hide()
	set_process(false)
	
func _process(delta) -> void:
	lifetime += delta
	position += direction * speed
	
	# If already dead, run death process instead of the rest of normal process
	if is_queued_for_despawn:
		death_process()
		return
	
	turn()
	_handle_border_culling()
	_handle_collision()

func _handle_border_culling() -> void:
	if (!Global.stage_entity_factory.bounding_box.has_point(position)):
		die(DEATH_TYPE.OFF_SCREEN)
		return

func _handle_collision() -> void:
	if !is_tangible(): return
	if position.distance_squared_to(Global.player.position) < pow($CollisionShape2d.shape.radius + Global.player.get_node("CollisionShape2d").shape.radius, 2):
		Global.player.on_hit()

func death_process() -> void:
	modulate.a = max(modulate.a * 0.9, 0.0)

func init_entity(posn, init_angle, init_speed, init_type, init_health, init_resist, init_behaviour = null) -> void:
	# Physics properties
	position = posn
	set_angle(init_angle)
	speed = init_speed
	
	# Sprite properties
	type = init_type
	max_health = init_health
	cur_health = max_health
	modulate.a = 1.0
	
	# Entity properties
	lifetime = 0
	resist = init_resist
	freed = false
	is_queued_for_despawn = false
	$CollisionShape2d.disabled = false
	set_behaviour(init_behaviour)
	idle()
	show()
	set_process(true)

func set_angle(new_angle) -> void:
	angle = wrapf(new_angle, 0, 2*PI)
	direction = Vector2.RIGHT.rotated(angle)
	
func idle() -> void:
	travel_anim_state("Idle")
	
func turn() -> void:
	if PI/2 > angle || angle > 3*PI/2:
		travel_anim_state("MoveRight")
	elif PI/2 < angle && angle < 3*PI/2:
		travel_anim_state("MoveLeft")
	else:
		idle()
	$Sprite2d.set_flip_h(match_anim_state("Left"))

func die(d_type : DEATH_TYPE) -> void:
	# TODO: death animation
	death_type = d_type
	$DespawnTimer.start()
	is_queued_for_despawn = true
	Global.debug.dprint("Entity died by: " + DEATH_TYPE.keys()[death_type])

func take_damage(damage : float) -> void:
	if cur_health <= 0: return
	cur_health -= damage * (1-resist)
	cur_health = max(0, cur_health)
	if cur_health <= 0:
		die(DEATH_TYPE.EXPLODE_PRIZE)

func match_anim_state(s : String) -> bool:
	return str(state_machine.get_current_node()).contains(s)

func travel_anim_state(s : String) -> void:
	state_machine.travel(TYPE.keys()[type] + "_" + s)

func is_alive() -> bool:
	return !freed && !is_queued_for_despawn

func is_tangible() -> bool:
	return !$CollisionShape2d.disabled

func set_tangible(tangible : bool) -> void:
	$CollisionShape2d.disabled = !tangible
	
func set_behaviour(new_behaviour) -> void:
	for obj in $BehaviourContainer.get_children():
		obj.queue_free()
	var new_node : Node = Node.new()
	$BehaviourContainer.add_child(new_node)
	new_node.set_script(new_behaviour)
	if new_behaviour: new_node._ready()

func despawn_entity() -> void:
	freed = true
	is_queued_for_despawn = false
	set_behaviour(null)
	set_tangible(false)
	hide()
	set_process(false)

func _on_despawn_timer_timeout():
	despawn_entity()
