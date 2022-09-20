extends CharacterBody2D
class_name Player

const INVULNERABLE_DURATION : float = 1.0

@export var speed : float = 6
@export var slow_speed : float = 2.5
var invulnerable : bool = false

func get_class(): return "Player"
func is_class(cls): return cls == "Player"

func _ready():
	GlobalVariables.player = self
	$InvulnerableTimer.set_wait_time(INVULNERABLE_DURATION)

func _process(_delta):
	# Read movement direction from input
	var input_direction := Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	).normalized()
	
	# Read slow or normal movement speed
	var is_slow := Input.get_action_strength("slow")
	
	# Move Player
	self.position += input_direction * (slow_speed if is_slow else speed)
	
	# Clamp Player position to borders
	self.position = Vector2(
		clamp(self.position.x, -GlobalConstants.PLAYER_MARGIN, GlobalConstants.PLAY_AREA_SIZE.x + GlobalConstants.PLAYER_MARGIN),
		clamp(self.position.y, -GlobalConstants.PLAYER_MARGIN, GlobalConstants.PLAY_AREA_SIZE.y + GlobalConstants.PLAYER_MARGIN)
	)

func on_hit():
	if (!self.invulnerable):
		print("Hit!")
		self.invulnerable = true
		$InvulnerableTimer.start()


func _on_invulnerable_timer_timeout():
	self.invulnerable = false
