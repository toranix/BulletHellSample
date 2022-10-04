extends CharacterBody2D
class_name Player

const INVULNERABLE_DURATION : float = 1.0
const PLAYER_MARGIN : float = 10

@export var speed : float
@export var slow_speed : float
var invulnerable : bool = false
var is_basic_shot_on_cooldown : bool = false

func _ready():
	Global.player = self
	$InvulnerableTimer.set_wait_time(INVULNERABLE_DURATION)
	$HitboxSprite.scale = Vector2(0,0)
	init_char(1.5, 6, 2.5)

func _process(_delta):
	# Read movement direction from input
	var input_direction := Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	).normalized()
	
	# Read slow or normal movement speed
	var is_slow := Input.get_action_strength("slow")
	
	# Read player shooting input
	var is_shoot := Input.get_action_strength("confirm")
	if is_shoot:
		_handle_shoot(is_slow)
	
	# Move Player
	self.position += input_direction * (slow_speed if is_slow else speed)
	
	# Clamp Player position to borders
	self.position = Vector2(
		clamp(self.position.x, PLAYER_MARGIN, Global.PLAY_AREA_SIZE.x - PLAYER_MARGIN),
		clamp(self.position.y, PLAYER_MARGIN, Global.PLAY_AREA_SIZE.y - PLAYER_MARGIN)
	)
	
	_update_animation(input_direction, is_slow)

# Sets the specific character's attributes
func init_char(hitbox : float, spd : float, slow_spd : float) -> void:
	$CollisionShape2d.shape.radius = hitbox
	speed = spd
	slow_speed = slow_spd
	self.position = Global.SPAWN_POSN

# Called when hit by a bullet (or enemy)
func on_hit():
	if (!self.invulnerable):
		print("Hit!")
		self.invulnerable = true
		$InvulnerableTimer.start()

# Player shooting method
func _handle_shoot(is_slow) -> void:
	# Basic shots
	if !is_basic_shot_on_cooldown:
		pass

# Updates animation states for both the character and hitbox sprites
func _update_animation(input_direction : Vector2, is_slow : bool) -> void:
	# Character body animation
	var current_animation = $CharacterSprite.animation
	if (input_direction.x < 0 && current_animation != "MoveLeft"):
		$CharacterSprite.animation = "MoveLeft"
	elif (input_direction.x > 0 && current_animation != "MoveRight"):
		$CharacterSprite.animation = "MoveRight"
	elif (input_direction.x == 0 && current_animation != "Idle"):
		$CharacterSprite.animation = "Idle"

	# Hitbox indicator animation
	$HitboxSprite.rotation += 0.05
	if is_slow:
		$HitboxSprite.scale.x = min($HitboxSprite.scale.x + 0.1, 1.0)
		$HitboxSprite.scale.y = min($HitboxSprite.scale.y + 0.1, 1.0)
	else:
		$HitboxSprite.scale.x = max($HitboxSprite.scale.x - 0.1, 0.0)
		$HitboxSprite.scale.y = max($HitboxSprite.scale.y - 0.1, 0.0)

func _on_invulnerable_timer_timeout():
	self.invulnerable = false
