extends PanelContainer

onready var bar = $Lifebar

func _ready():
	player_stats.connect("health_updated", self, "render_health")

func render_health():
	bar.decrease_life(player_stats.health)
