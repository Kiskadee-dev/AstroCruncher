extends "res://BulletSystem/Bullet2D.gd"
var damage = 20

func on_ready():
	use_lifespan = false
	default_lifespan = 15
	use_screen_visibility = true
	force_physics = true
	.on_ready()

func _ready():
	on_ready()

func _load():
	._load()
	$Asteroid.set_deferred("monitoring", true)

func _unload():
	._unload()
	$Asteroid.set_deferred("monitoring", false)

func _on_Asteroid_body_entered(body):
	if body:
		body = body as Node2D
		if body.is_in_group("player"):
			player_stats.damage(damage)
			_unload()
func _reset():
	._reset()
	scale = Vector2(1,1)
