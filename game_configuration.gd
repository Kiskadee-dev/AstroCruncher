extends Node

var music:bool = true setget manage_music
var sfx:bool = true

signal stop_music
signal start_music

func manage_music(new_value):
	music = new_value
	if not music:
		emit_signal("stop_music")
	else:
		emit_signal("start_music")
