extends Node2D

export (PackedScene) var Asteroid
export (PackedScene) var Enemy01
var SpawnPositions:Line2D

var max_position:Vector2
var min_position:Vector2


func _ready():
	get_viewport().connect("size_changed", self, "update_spawn")
	update_spawn()
	yield(get_tree().create_timer(1), "timeout")
	wave1()


func update_spawn():
	max_position = get_viewport().get_visible_rect().end
	max_position.y = 0
	min_position = get_viewport().get_visible_rect().end

func wave1():
	for j in range(80):
		for i in range(10):
			var scale:float = rand_range(1, 3)
			var b:Node2D = BulletSystem.fire(Asteroid, Vector2(max_position.x+20, rand_range(max_position.y, min_position.y)), 180, 100) #100/scale
			b.scale = Vector2(scale, scale)
			yield(get_tree().create_timer(.2), "timeout")
		yield(get_tree().create_timer(rand_range(2, 4)), "timeout")
		for i in range(3):
				var e:Node2D = BulletSystem.fire(Enemy01, Vector2(max_position.x+20, rand_range(max_position.y, min_position.y)), 180, 100) #100/scale
				e.shoot_pat1()
		yield(get_tree().create_timer(1), "timeout")

func _process(delta):
	pass

func spawn_enemy():
	pass
