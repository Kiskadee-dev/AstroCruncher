extends Particles2D

var player:KinematicBody2D

func _ready():
	player_stats.connect("shield_over", self, "start_destroy")

func _process(_delta):
	if player:
		position = player.position
	if player_stats.shield:
		pass
	else:
		emitting = false

func start_destroy():
	$Area2D.set_deferred("monitoring", false)
	var t = Timer.new()
	add_child(t)
	t.wait_time = 6
	t.connect("timeout", self, "end_destroy")

func end_destroy():
	call_deferred("queue_free")
