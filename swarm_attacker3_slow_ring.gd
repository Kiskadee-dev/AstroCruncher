extends Node2D

var projectile = preload("res://Bullets/EnemyBullet.tscn")
onready var timer = Timer.new()
var shooting:bool = false
signal shooting_finished
var locked_target:bool

var rot:float = 0
var alpha:int=0

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
	queue_free()

var shooted:int = 0

func start_pattern():
	timer.disconnect("timeout", self, "start_pattern")
	timer.wait_time = .1
	shooting = true
	shooted = 0
	#timer.start()

func _process(delta):
	if shooting and not player_stats.dead:
		if shooted < 160:
			timer.start()
			rot = shooted+shooted*50
			#rotation_degrees = shooted
			alpha=shooted
			shoot()
			shooted += 1
			yield(get_tree().create_timer(1), "timeout")
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
		var i = BulletSystem.fire(projectile, global_position, rot, 200, get_parent())
		i.damage = 5
		i.scale = Vector2(.2,.2)
	else:
		return