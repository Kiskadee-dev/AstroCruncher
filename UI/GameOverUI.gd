extends Control

func _ready():
	player_stats.connect("game_over", self, "show")
