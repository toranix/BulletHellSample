extends Node2D

var frame = 0
var split = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	Engine.set_target_fps(GlobalConstants.FRAMERATE)
	$PlayAreaContainer.position = (GlobalConstants.WINDOW_SIZE - GlobalConstants.PLAY_AREA_SIZE) / 2
	$PlayAreaContainer.size = GlobalConstants.PLAY_AREA_SIZE

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	frame += 1
	if (frame % 5 == 0): $FramerateLabel.text = str(Engine.get_frames_per_second())
	$BulletCountLabel.text = str(GlobalVariables.active_bullet_count)
	$MemoryLabel.text = str(Performance.get_monitor(Performance.MEMORY_STATIC)/1024.0/1024.0) + "MB"
	if (frame % 7 == 0):
		for n in split:
			GlobalVariables.bullet_factory.spawn_bullet(
				GlobalConstants.PLAY_AREA_SIZE / 2,
				((frame * 17) + (n * 360 / split)) * PI / 180,
				2.5,
				0,
				(frame + n) % GlobalConstants.colour.size())
