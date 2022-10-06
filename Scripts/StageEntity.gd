extends CharacterBody2D
class_name StageEntity

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

func _ready() -> void:
	state_machine = $AnimationTree["parameters/playback"]
	init_entity(Global.debug_homing_position, PI/2, 0.0, 0, 100.0, 0.0)
	$CollisionShape2d.shape.radius = 10.0
#	hide()
#	set_process(false)
	
func _process(_delta) -> void:
	var distance_to = position.distance_to(Global.debug_new_homing_position)
	var old_angle = angle
	set_angle(position.direction_to(Global.debug_new_homing_position).angle())
	speed = distance_to * 0.05
	
	if speed <= 0.2:
		speed = 0
		set_angle(PI/2)
		idle()
	else:
		turn(old_angle, angle)
	
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
	show()
	set_process(true)

func set_angle(new_angle) -> void:
	angle = wrapf(new_angle, 0, 2*PI)
	direction = Vector2.RIGHT.rotated(angle)
	
func idle() -> void:
	state_machine.travel("FAIRYBLUE_Idle")
	
func turn(old_angle, new_angle) -> void:
#	if (PI/2 <= old_angle && old_angle <= 3*PI/2) && (PI/2 > new_angle || new_angle > 3*PI/2) && target_state != "Right":
	if PI/2 > angle || angle > 3*PI/2:
		state_machine.travel("FAIRYBLUE_MoveRight")
#	elif (PI/2 < new_angle && new_angle < 3*PI/2) && (PI/2 >= old_angle || old_angle >= 3*PI/2) && target_state != "Left":
	elif PI/2 < angle && angle < 3*PI/2:
		state_machine.travel("FAIRYBLUE_MoveLeft")
	$Sprite2d.set_flip_h(match_anim_state("Left"))

func match_anim_state(s : String) -> bool:
	return str(state_machine.get_current_node()).contains(s)
