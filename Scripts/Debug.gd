extends Node2D
class_name Debug

var is_debug : bool

# Called when the node enters the scene tree for the first time.
func _ready():
	is_debug = false
	hide()
	Global.debug = self
	$FramerateLabel.show()
	$BulletCountLabel.hide()
	$MemoryLabel.show()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var debug = Input.get_action_strength("debug_on") - Input.get_action_strength("debug_off")
	if debug == 1.0 && !is_debug:
			is_debug = true
			show()
			dprint("DEBUG ON")
	elif debug == -1.0 && is_debug:
			is_debug = false
			hide()
			dprint("DEBUG OFF")
	
	$FramerateLabel.text = str(Engine.get_frames_per_second())
	$BulletCountLabel.text = str(Global.active_bullet_count)
	$MemoryLabel.text = str(Performance.get_monitor(Performance.MEMORY_STATIC)/1024.0/1024.0).pad_decimals(2) + " MB"

func to_stage() -> void:
	$BulletCountLabel.show()
	
func to_main_menu() -> void:
	$BulletCountLabel.hide()

func dprint(s) -> void:
	print("[DEBUG] " + str(s))
