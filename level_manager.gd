extends Node

var levels = {"0":"res://Scenes/test.tscn"}
var loading_something:bool = false

func start_level(n:int):
	if not loading_something:
		loading_something = true
		FadeSystem.fade_out()
		yield(FadeSystem, "done")
		get_tree().change_scene(levels[str(n)])
		FadeSystem.fade_in(1)
		loading_something = false

func exit_game():
	get_tree().quit()