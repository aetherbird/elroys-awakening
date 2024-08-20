extends Node2D

func _process(delta):
	change_scene()

func _on_cliffside_exitpoint_body_entered(body):
	if body.has_method("player"):
		realm.transition_scene = true

func _on_cliffside_exitpoint_body_exited(body):
	if body.has_method("player"):
		realm.transition_scene = false

func change_scene():
	if realm.transition_scene == true:
		if realm.current_scene == "cliff_side":
			get_tree().change_scene_to_file("res://scenes/world_a.tscn")
			realm.finish_scene_change()
