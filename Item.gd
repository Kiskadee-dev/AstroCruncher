extends Node2D

enum items{heal, shield, triple}

var hit_someone:bool = false

func _ready():
	var t = Timer.new()
	add_child(t)
	t.wait_time = 25
	t.connect("timeout", self, "destroy")
	t.start()

func destroy():
	queue_free()

func _process(delta):
	translate(Vector2(-1, 0)*30*delta)

func _on_Area2D_body_entered_something(body, effect):
	if visible:
		if body:
			body = body as Node2D
			if body.is_in_group("player") and not hit_someone:
				hit_someone = true
				match effect:
					items.heal:
						player_stats.heal(60)
					items.triple:
						player_stats.powerup(player_stats.powerups.triple)
				call_deferred("queue_free")