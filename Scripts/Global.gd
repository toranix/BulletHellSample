extends Node

const FRAMERATE : int = 60
const PLAY_AREA_SIZE := Vector2(600,670)
const WINDOW_SIZE := Vector2(1280,720)

var debug : bool = true
var player : Player
var bullet_factory : Node2D
var active_bullet_count : int = 0
