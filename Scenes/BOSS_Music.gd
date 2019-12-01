extends AudioStreamPlayer
onready var intro:AudioStream = preload("res://Music/SketchyLogic/BossIntro.ogg")
onready var boss_music:AudioStream = preload("res://Music/SketchyLogic/BossMain.ogg")

func start_music():
	if game_configuration.music:
		stream = intro
		play()
		yield(self, "finished")
		stream = boss_music
		play()
func stop_music():
	stop()