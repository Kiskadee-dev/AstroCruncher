extends Node

var levels = {"0":"res://Scenes/test.tscn"}

func start_level(n:int):
	get_tree().change_scene(levels[str(n)])

func exit_game():
	get_tree().quit()