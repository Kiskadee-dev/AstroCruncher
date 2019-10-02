extends "res://BulletSystem/Bullet2D.gd"

var damage = 3

func _ready():
	on_ready()

func on_ready():
	.on_ready()

func _load():
	$Area2D.set_deferred("monitoring", true)
	._load()

func _unload():
	$Area2D.set_deferred("monitoring", false)
	._unload()
