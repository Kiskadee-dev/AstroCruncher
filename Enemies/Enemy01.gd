extends "res://BulletSystem/Bullet2D.gd"

onready var projectile = preload("res://Bullets/EnemyBullet.tscn")

var damage = 10
var health = 30

func shoot_pat1():
	yield(get_tree().create_timer(4), "timeout")
	var p = get_tree().get_nodes_in_group("player")
	var original_rotation = rotation
	if len(p) > 0:
		var speed = current_speed
		change_speed(0)
		for i in range(3):
			if not visible:
				return
			look_at(p[0].position)
			shoot()
			yield(get_tree().create_timer(.5), "timeout")
		change_speed(speed)
		rotation = original_rotation

func shoot():
	if visible:
		var i = BulletSystem.fire(projectile, $shoot_point.global_position, rotation_degrees, 1000)
	else:
		return

func on_ready():
	use_lifespan = false
	.on_ready()

func _ready():
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
