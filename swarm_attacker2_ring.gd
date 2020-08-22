extends Node2D

var projectile = preload("res://Bullets/EnemyBullet.tscn")
onready var timer = Timer.new()
var shooting:bool = false
signal shooting_finished
var locked_target:bool

var rot:float = 0

func _ready():
	add_child(timer)
	call_deferred("attack")

func attack():
	$AnimationPlayer.play("spawn")
	yield($AnimationPlayer, "animation_finished")
	shoot_pat1()
	yield(self, "shooting_finished")
	$AnimationPlayer.play("despawn")
	yield($AnimationPlayer, "animation_finished")
	call_deferred("queue_free")

var shooted:int = 0

func start_pattern():
	timer.disconnect("timeout", self, "start_pattern")
	timer.wait_time = .1
	shooting = true
	shooted = 0
	#timer.start()

func _process(_delta):
	if shooting and not player_stats.dead:
		if shooted < 12:
			timer.start()
			rot = shooted*30
			shoot()
			shooted += 1
		else:
			shooting = false
			emit_signal("shooting_finished")

func shoot_pat1():
	#timer.stop()
	#timer.wait_time = 0
	timer.one_shot = true
	timer.connect("timeout", self, "start_pattern")
	start_pattern()
	#timer.start()

func shoot():
	if visible:
		var i = BulletSystem.fire(projectile, global_position, rot, 700, get_parent())
		i.damage = 10
	else:
		return
