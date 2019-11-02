extends Node2D

enum soundlib {boom}

onready var sound_library = {soundlib.boom:load("res://Music/SFX_scenes/boom.tscn")}

var active_audio = {}
var inactive_audio = {}

func play(sound_id):
	update_pool()
	if not sound_id in active_audio:
		active_audio[sound_id] = []
		inactive_audio[sound_id] = []

	if sound_id in inactive_audio:
		if not inactive_audio[sound_id].empty():
			var s = inactive_audio[sound_id].pop_front()
			s.play()
			active_audio[sound_id].append(s)
		else:
			var new_sound = sound_library[sound_id].instance()
			add_child(new_sound)
			new_sound.play()
			active_audio[sound_id].append(new_sound)

func update_pool():
	for sound_id in active_audio:
		for sound in active_audio[sound_id]:
			sound = sound as AudioStreamPlayer
			if not sound.playing:
				active_audio[sound_id].erase(sound)
				inactive_audio[sound_id].append(sound)