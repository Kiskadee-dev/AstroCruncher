extends AudioStreamPlayer

func start_music():
	if game_configuration.music:
		play()

func stop_music():
	stop()