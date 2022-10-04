extends Node

const FRAMERATE : int = 60
const PLAY_AREA_SIZE := Vector2(600,670)
const WINDOW_SIZE := Vector2(1280,720)
const SPAWN_POSN := Vector2(300,600)

var debug : bool = true
var player : Player
var player_bullet_factory : Node2D
var enemy_bullet_factory : Node2D
var active_bullet_count : int = 0
