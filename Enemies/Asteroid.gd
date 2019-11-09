extends "res://BulletSystem/Bullet2D.gd"
var damage = 30
var health = 30
var player_score = 20

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

func _reset():
	._reset()
	health = 30
	scale = Vector2(1,1)
	var chance = rand_range(0, 100)
	if chance < 50:
		$AnimatedSprite.play("Rotate up")
	else:
		$AnimatedSprite.play("Rotate right")
	var frame = int(rand_range(0,len($AnimatedSprite.frames.frames)))
	$AnimatedSprite.frame = frame

func damage(value):
	health -= value
	health = clamp(health, 0, 100)
	if health == 0:
		player_stats.add_score(player_score)
		player_stats.spawn_thing_chance(self)
		_unload()

func _on_Asteroid_body_entered(body):
	if visible:
		if body:
			body = body as Node2D
			if player_stats.collide(self, body):
				_unload()

var bullet_explosion_effect = preload("res://explosion_bullet.tscn")

func _on_Asteroid_area_entered(area):
	if visible:
		if area:
			area = area as Area2D
			if area.monitoring:
				var p = area.get_parent()
				if p.is_in_group("player_bullet"):
					if p.visible and not p.hit_someone:
						p.hit_someone = true
						damage(p.damage)
						var ex = bullet_explosion_effect.instance()
						get_parent().add_child(ex)
						ex.position = p.position
						p._unload()
