extends Node

var player_current_attack = false

var current_scene = "world_a" # world cliff_side
var transition_scene = false

var player_exit_cliffside_posx = 176
var player_exit_cliffside_posy = 14
var player_start_posx = 62
var player_start_posy = 16

var game_first_load = true

@onready var animation_player = %fade_transition

func _ready():
	# Connect the signal using a Callable
	connect("play_animation", Callable(self, "_on_play_animation"))

func _on_play_animation(animation_name: String):
	animation_player.play(animation_name)

signal play_animation(animation_name: String)

func request_animation(animation_name: String):
	emit_signal("play_animation", animation_name)

func finish_scene_change():
	if transition_scene == true:
		transition_scene = false
	if current_scene == "world_a":
		current_scene = "cliff_side"
	else:
		current_scene = "world_a"
