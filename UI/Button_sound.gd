extends Button

func _process(delta):
	if game_configuration.music:
		modulate = Color.green
	else:
		modulate = Color.red


func _on_Button_sound_button_down():
	game_configuration.music = not game_configuration.music
