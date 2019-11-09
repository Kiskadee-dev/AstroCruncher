extends AudioStreamPlayer

func _ready():
	if game_configuration.music:
		play()
	game_configuration.connect("start_music", self, "start_music")
	game_configuration.connect("stop_music", self, "stop_music")

func stop_music():
	stop()

func start_music():
	play()
