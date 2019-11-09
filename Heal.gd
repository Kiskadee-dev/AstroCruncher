extends Node2D

var hit_someone:bool = false

func _ready():
	var t = Timer.new()
	add_child(t)
	t.wait_time = 15
	t.connect("timeout", self, "destroy")
	t.start()

func destroy():
	queue_free()

func _process(delta):
	translate(Vector2(-1, 0)*30*delta)

func _on_Area2D_body_entered(body):
	if visible:
		if body:
			body = body as Node2D
			if body.is_in_group("player") and not hit_someone:
				hit_someone = true
				player_stats.heal(60)
				queue_free()