extends Node2D

@export var follow_speed: float = 5.0
@export var float_amplitude: float = 10.0
@export var float_speed: float = 2.0
@export var random_movement_intensity: float = 30.0  # Controls random movement range
@export var hover_distance: float = 50.0  # Distance from player to hover

var time_passed: float = 0.0
var target: CharacterBody2D  # The player node

func _ready():
	target = get_tree().root.get_node("player") as CharacterBody2D  # Ensure we're referencing the correct node type
	randomize()

func _process(delta):
	if target:
		var target_position = target.global_position

		# Calculate circular hovering movement around the player
		var hover_movement = Vector2(
			hover_distance * cos(time_passed * float_speed),
			hover_distance * sin(time_passed * float_speed)
		)

		# Calculate random offset for organic movement
		var random_offset = Vector2(
			randf_range(-random_movement_intensity, random_movement_intensity),
			randf_range(-random_movement_intensity, random_movement_intensity)
		)

		# Combine movements
		var final_position = target_position + hover_movement + random_offset

		# Smoothly move towards the calculated position
		global_position = global_position.lerp(final_position, follow_speed * delta)

		# Increment time for continuous movement
		time_passed += delta
