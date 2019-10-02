extends "res://BulletSystem/Bullet2D.gd"

var damage = 3

func _ready():
	on_ready()

func on_ready():
	.on_ready()

func _load():
	._load()
	$Area2D.set_deferred("monitoring", true)

func _unload():
	._unload()
	$Area2D.set_deferred("monitoring", false)

func _on_Area2D_area_entered(area):
	pass

func _on_Area2D_body_entered(body):
	if body:
		body = body as Node2D
		if body.is_in_group("player") and not hit_someone:
			hit_someone = true
			player_stats.damage(damage)
			_unload()
