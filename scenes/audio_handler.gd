extends Node
## Primary audio node of the game

## Intended to handle music and ambience for the game
## Possibly all audio?

func _ready() -> void:
	start_game_audio()

func start_game_audio():
	$"AudioBlizzard1".play()

func _on_piano_music_timer_timeout():
	$"AudioPiano1".play()
