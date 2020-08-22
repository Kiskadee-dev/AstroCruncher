extends AudioStreamPlayer
var Error = load("res://ErrorHandler/Error.gd").new()
func _ready():
	if game_configuration.music:
		play()
	Error.handle(game_configuration.connect("start_music", self, "start_music"))
	Error.handle(game_configuration.connect("stop_music", self, "stop_music"))

func stop_music():
	stop()

func start_music():
	play()
