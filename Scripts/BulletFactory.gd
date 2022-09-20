extends Node2D

var bullet = preload("res://Objects/Bullet.tscn")

func _ready():
	GlobalVariables.bullet_factory = self
	for n in GlobalConstants.BULLET_CAPACITY:
		add_child(bullet.instantiate())

func get_bullet() -> Bullet:
	for b in get_children():
		if b.freed: return b
	return null

func spawn_bullet(posn, angle, init_speed, type, colour) -> void:
	var b = get_bullet()
	if b: b.init_bullet(posn, angle, init_speed, type, colour)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta) -> void:
	pass

func _physics_process(_delta) -> void:
	pass
