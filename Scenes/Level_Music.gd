extends AudioStreamPlayer

func _ready():
	start_music()

func start_music():
	if game_configuration.music:
		play()