extends "res://BulletSystem/Bullet2D.gd"
var damage = 30
var health = 30

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
		if body.is_in_group("player") and not hit_someone:
			hit_someone = true
			player_stats.damage(damage)
			_unload()
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
		_unload()


func _on_Asteroid_area_entered(area):
	if area:
		area = area as Area2D
		if area.monitoring:
			var p = area.get_parent()
			if p.is_in_group("player_bullet"):
				if p.visible and not p.hit_someone:
					p.hit_someone = true
					damage(p.damage)
					p._unload()
