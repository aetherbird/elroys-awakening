extends Node2D

@onready var player = $player

func _ready():
	if realm.game_first_load == true:
		player.position.x = realm.player_start_posx
		player.position.y = realm.player_start_posy
	else:
		player.position.x = realm.player_exit_cliffside_posx
		player.position.y = realm.player_exit_cliffside_posy

func _process(delta):
	change_scene()

func _on_cliffside_transition_point_body_entered(body):
	if body.has_method("player"):
		realm.transition_scene = true

func _on_cliffside_transition_point_body_exited(body):
	if body.has_method("player"):
		realm.transition_scene = false

func change_scene():
	if realm.transition_scene == true and realm.current_scene == "world_a":
		weather.play_fade_to_black()
		var timer = Timer.new()
		timer.wait_time = .3  # Adjust according to the fade-to-black animation length
		timer.one_shot = true
		timer.connect("timeout", Callable(self, "_on_fade_to_black_complete"))
		add_child(timer)
		timer.start()

func _on_fade_to_black_complete():
	get_tree().change_scene_to_file("res://scenes/cliff_side.tscn")
	realm.game_first_load = false
	realm.finish_scene_change()
	weather.play_fade_from_black()
