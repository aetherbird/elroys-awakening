extends Node2D

@export var follow_speed: float = 5.0
var target: CharacterBody2D

func _ready():
	target = get_tree().root.get_node("player") as CharacterBody2D

func _process(delta):
	if target:
		# Directly move towards the player's position
		global_position = global_position.lerp(target.global_position, follow_speed * delta)
