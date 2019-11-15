extends PanelContainer

onready var bar = $Lifebar_Boss

func _ready():
	player_stats.connect("boss_health_updated", self, "render_health")
	player_stats.connect("show_boss_health", self, "show_health")
func show_health():
	show()
func render_health():
	bar.decrease_life(player_stats.boss_health)