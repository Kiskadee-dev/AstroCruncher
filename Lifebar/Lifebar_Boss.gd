extends PanelContainer

onready var bar = $Lifebar_Boss

func render_health():
	bar.decrease_life(player_stats.health)