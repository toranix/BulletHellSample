extends Node

const FRAMERATE : int = 60
const PLAY_AREA_SIZE := Vector2(600,670)
const WINDOW_SIZE := Vector2(1280,720)
const SPAWN_POSN := Vector2(300,600)

var debug : Debug
var player : Player
var player_bullet_factory : Node2D
var enemy_bullet_factory : Node2D
var active_bullet_count : int = 0

var debug_homing_position : Vector2 = Vector2(300,200)
var debug_new_homing_position : Vector2 = Vector2(300,200)
