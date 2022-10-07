extends CharacterBody2D
class_name StageEntity

enum DEATH_TYPE {EXPLODE_PRIZE, EXPLODE_EMPTY, OFF_SCREEN, BOSS}

const DESPAWN_DELAY : float = 0.15

@export var angle : float
@export var max_health : float
@export var resist : float
@export var show_health : bool
@export var speed : float
@export var type : int

var cur_health : float
var direction : Vector2
var freed : bool
var is_queued_for_despawn : bool
var state_machine : AnimationNodeStateMachinePlayback
var death_type : DEATH_TYPE

func _ready() -> void:
	state_machine = $AnimationTree["parameters/playback"]
	$DespawnTimer.wait_time = DESPAWN_DELAY
	$CollisionShape2d.disabled = true
	init_entity(Global.debug_homing_position, PI/2, 0.0, 0, 1000.0, 0.0)
	$CollisionShape2d.shape.radius = 10.0
#	hide()
#	set_process(false)
	
func _process(_delta) -> void:
	var distance_to = position.distance_to(Global.debug_new_homing_position)
	set_angle(position.direction_to(Global.debug_new_homing_position).angle())
	speed = distance_to * 0.05
	
	if speed <= 0.2:
		speed = 0
		set_angle(PI/2)
		idle()
	else:
		turn()
	
	position += direction * speed

func init_entity(posn, init_angle, init_speed, init_type, init_health, init_resist) -> void:
	# Physics properties
	position = posn
	set_angle(init_angle)
	speed = init_speed
	
	# Sprite properties
	type = init_type
	max_health = init_health
	cur_health = max_health
	
	# Entity properties
	resist = init_resist
	freed = false
	is_queued_for_despawn = false
	$CollisionShape2d.disabled = false
	show()
	set_process(true)

func set_angle(new_angle) -> void:
	angle = wrapf(new_angle, 0, 2*PI)
	direction = Vector2.RIGHT.rotated(angle)
	
func idle() -> void:
	state_machine.travel("FAIRYBLUE_Idle")
	
func turn() -> void:
	if PI/2 > angle || angle > 3*PI/2:
		state_machine.travel("FAIRYBLUE_MoveRight")
	elif PI/2 < angle && angle < 3*PI/2:
		state_machine.travel("FAIRYBLUE_MoveLeft")
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

func despawn_entity() -> void:
	freed = true
	is_queued_for_despawn = false
	$CollisionShape2d.disabled = true
	hide()
	set_process(false)

func _on_despawn_timer_timeout():
	despawn_entity()
