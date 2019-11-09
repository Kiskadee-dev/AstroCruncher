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

func _process(delta):
	if attack:
		for i in childs:
			if i.attacking:
				return
		emit_signal("attack_finished")
		call_deferred("queue_free")