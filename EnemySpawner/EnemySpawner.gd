extends Node2D

signal wave_finished

export (PackedScene) var Asteroid
export (PackedScene) var Enemy01
export (PackedScene) var Enemy02
var SpawnPositions:Line2D

var max_position:Vector2
var min_position:Vector2

onready var screensize = get_viewport_rect().size

func _ready():
	randomize()
	get_viewport().connect("size_changed", self, "update_spawn")
	update_spawn()
	yield(get_tree().create_timer(1), "timeout")
	call_deferred("spawn_enemies")

func spawn_enemies():
	wave1()
	yield(self, "wave_finished")
	wave2()
	yield(self, "wave_finished")
	wave1()
	wave2()
	yield(self, "wave_finished")
	yield(self, "wave_finished")
	wave3()
	yield(self, "wave_finished")
	wave3()
	wave2()
	yield(self, "wave_finished")
	yield(self, "wave_finished")
	wave3()
	wave2()
	wave1()
	yield(self, "wave_finished")
	yield(self, "wave_finished")
	yield(self, "wave_finished")
	var m = $Level_Music
	var t = Tween.new()
	add_child(t)
	t.interpolate_property(m, "volume_db", 0, -80, 2, Tween.TRANS_LINEAR, Tween.EASE_IN, 0)
	t.start()
	yield(get_tree().create_timer(4), "timeout")
	m.stop()
	$BOSS_Music.start_music()
	t.queue_free()
	get_node("../boss/AnimationPlayer").play("spawn")
	yield(get_node("../boss/AnimationPlayer"), "animation_finished")
	get_node("../boss").start_boss()
	get_node("../boss/AnimationPlayer").play("idle")

func update_spawn():
	max_position = get_viewport().get_visible_rect().end
	max_position.y = 0
	min_position = get_viewport().get_visible_rect().end

func wave1(): #Asteroids
	var t = Timer.new()
	add_child(t)
	t.one_shot = true
	for j in range(5):
		for i in range(rand_range(10, 25)):
			var scale:float = rand_range(1, 3)
			var b:Node2D = BulletSystem.fire(Asteroid, Vector2(max_position.x+20, rand_range(max_position.y, min_position.y)), 180, 100, get_parent()) #100/scale
			b.scale = Vector2(scale, scale)
			b.position.y = clamp(b.position.y, 100, screensize.y-100)
			yield(get_tree().create_timer(.2), "timeout")
		yield(get_tree().create_timer(rand_range(2, 4)), "timeout")
	emit_signal("wave_finished")

func wave2():
	for w in range(5):
		for i in range(3):
				var e:Node2D = BulletSystem.fire(Enemy01, Vector2(max_position.x+20, rand_range(max_position.y, min_position.y)), 180, 100, get_parent()) #100/scale
				e.shoot_pat1()
				e.position.y = clamp(e.position.y, 100, screensize.y-100)
				yield(get_tree().create_timer(1), "timeout")
		yield(get_tree().create_timer(2), "timeout")
		for i in range(3):
				var e:Node2D = BulletSystem.fire(Enemy02, Vector2(max_position.x+20, rand_range(max_position.y, min_position.y)), 180, 100, get_parent()) #100/scale
				e.shoot_pat1()
				e.position.y = clamp(e.position.y, 100, screensize.y-100)
				yield(get_tree().create_timer(1), "timeout")
		yield(get_tree().create_timer(1), "timeout")
	emit_signal("wave_finished")

func wave3():
	for w in range(5):
		for i in range(3):
				var e:Node2D = BulletSystem.fire(Enemy01, Vector2(max_position.x+20, rand_range(max_position.y, min_position.y)), 180, 100, get_parent()) #100/scale
				e.shoot_pat1()
				e.position.y = clamp(e.position.y, 100, screensize.y-100)
				yield(get_tree().create_timer(.2), "timeout")
		yield(get_tree().create_timer(2), "timeout")
		for i in range(3):
				var e:Node2D = BulletSystem.fire(Enemy02, Vector2(max_position.x+20, rand_range(max_position.y, min_position.y)), 180, 100, get_parent()) #100/scale
				e.shoot_pat1()
				e.position.y = clamp(e.position.y, 100, screensize.y-100)
				yield(get_tree().create_timer(.2), "timeout")
		yield(get_tree().create_timer(1), "timeout")
	emit_signal("wave_finished")

func _process(delta):
	pass

func spawn_enemy():
	pass
