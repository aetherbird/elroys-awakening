extends Node

@onready var fade_animation_player = $fade_transition  # Reference to the AnimationPlayer node
@onready var color_rect = $fade_transition/canva_color/ColorRect

func _ready():
	color_rect.visible = false

# Method to play the fade-in transition
func play_fade_to_black():
	if fade_animation_player and fade_animation_player.has_animation("fade_to_black"):
		fade_animation_player.play("fade_to_black")

# Method to play the fade-out transition
func play_fade_from_black():
	if fade_animation_player and fade_animation_player.has_animation("fade_from_black"):
		fade_animation_player.play("fade_from_black")
