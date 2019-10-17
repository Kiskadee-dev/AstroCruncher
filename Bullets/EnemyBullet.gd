extends "res://BulletSystem/Bullet2D.gd"

var damage = 1

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
	area = area as Area2D
	if area:
		if area.is_in_group("shield") and player_stats.shield:
			_unload()

func _on_Area2D_body_entered(body):
	if body:
		body = body as Node2D
		if player_stats.collide(self, body):
			_unload()
