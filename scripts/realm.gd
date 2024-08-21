extends Node

var player_current_attack = false

var current_scene = "world_a" # world cliff_side
var transition_scene = false

var player_exit_cliffside_posx = 176
var player_exit_cliffside_posy = 14
var player_start_posx = 62
var player_start_posy = 16

var game_first_load = true

func finish_scene_change():
	if transition_scene == true:
		transition_scene = false
	if current_scene == "world_a":
		current_scene = "cliff_side"
	else:
		current_scene = "world_a"
