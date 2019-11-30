extends Button

func _on_Button_play_button_down():
	level_manager.start_level(0)

func return_to_menu():
	level_manager.start_level("menu")