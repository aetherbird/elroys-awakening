extends Node2D

@onready var audio_blizzard_1 = $"world-sound/AudioBlizzard1"
@onready var audio_piano_1 = $"world-sound/AudioPiano1"

func _ready():
	audio_blizzard_1.play()

func _on_cliffside_transition_point_body_entered(body):
	if body.has_method("player"):
		realm.transition_scene = true

func _on_cliffside_transition_point_body_exited(body):
	if body.has_method("player"):
		realm.transition_scene = false

func change_scene():
	if realm.transition_scene == true:
		if realm.current_scene == "world":
			get_tree().change_scene_to_file("res://scenes/cliff_side.tscn")
			realm.finish_scene_change()

func _on_piano_music_timer_timeout():
	audio_piano_1.play()
