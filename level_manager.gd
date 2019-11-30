extends Node

var levels = {"menu":"res://Scenes/MainMenu.tscn","0":"res://Scenes/Nivel 1.tscn"}
var loading_something:bool = false

func start_level(id):
	if not loading_something:
		loading_something = true
		FadeSystem.fade_out()
		yield(FadeSystem, "done")
		get_tree().change_scene(levels[str(id)])
		BulletsPool.clean_cache()
		FadeSystem.fade_in(1)
		loading_something = false
		player_stats.new_game()
		yield(get_tree().create_timer(5), "timeout")
		BulletsPool.cleaning_cache = false

func exit_game():
	get_tree().quit()