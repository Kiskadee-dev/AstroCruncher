extends Node2D

var childs = []
var attack:bool = false

signal attack_finished

func start_attack():
	attack = true
	for i in childs:
		i.pattern()

func _ready():
	childs = get_children()

func done()->bool:
	var c = get_children()
	for i in c:
		if not i.done: 
			return false
		if i.attacking:
			return false
	return true

func _process(delta):
	if attack:
		for i in childs:
			if i.attacking:
				return
		emit_signal("attack_finished")
		hide()
		position = Vector2(2000,2000)
		yield(get_tree().create_timer(10), "timeout")
		if done():
			call_deferred("queue_free")