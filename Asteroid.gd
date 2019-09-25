extends Area2D
var damage = 20
func _physics_process(delta):
	pass

func _on_Asteroid_body_entered(body):
	if body:
		body = body as Node2D
		if body.is_in_group("player"):
			player_stats.damage(damage)
			call_deferred("queue_free")
