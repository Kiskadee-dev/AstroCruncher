extends "res://BulletSystem/Bullet2D.gd"

onready var projectile = preload("res://Bullets/EnemyBullet.tscn")

var damage = 10
var health = 30

func shoot_pat1():
	for j in range(4):
		var orot = rotation_degrees
		var ospeed = current_speed
		yield(get_tree().create_timer(4), "timeout")
		current_speed = 0
		var s = rand_range(0, 36)
		for i in range(s, 36+s):
			rotation_degrees = i*10
			shoot()
			yield(TimersPool.create_timer(.1), "timeout")
		rotation_degrees = orot
		current_speed = ospeed


func shoot():
	if visible:
		var i = BulletSystem.fire(projectile, $shoot_point.global_position, rotation_degrees, 600, get_parent())
	else:
		return

func on_ready():
	use_lifespan = true
	default_lifespan = 20
	pooleable = false
	.on_ready()

func _ready():
	shoot_pat1()
	on_ready()

func _reset():
	._reset()
	health = 30

func _load():
	._load()
	$Area2D.set_deferred("monitoring", true)

func _unload():
	._unload()
	$Area2D.set_deferred("monitoring", false)

func damage(value):
	health -= value
	health = clamp(health, 0, 100)
	if health == 0:
		_unload()

func _on_Area2D_body_entered(body):
	if visible:
		if body:
			body = body as Node2D
			if body.is_in_group("player") and not hit_someone:
				hit_someone = true
				player_stats.damage(damage)
				_unload()

func _on_Area2D_area_entered(area):
	if visible:
		if area:
			area = area as Area2D
			if area.monitoring:
				var p = area.get_parent()
				if p.is_in_group("player_bullet"):
					if p.visible and not p.hit_someone:
						p.hit_someone = true
						damage(p.damage)
						p._unload()
