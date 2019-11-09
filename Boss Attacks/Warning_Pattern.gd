extends Node2D

onready var areas = []
var num_areas
var last_chosen:int = -1

signal attack_finished
var attacking:bool = false

func _ready():
	areas = get_children()
	num_areas = len(areas)
	for i in areas:
		i.visible = false
		
func pattern():
	for i in range(10):
		attacking = true
		var chosen:int = rand_range(0, num_areas-1)
		while(chosen == last_chosen):
			chosen = rand_range(0, num_areas-1)
		last_chosen = chosen
		var current = areas[chosen]
		current.visible = true
		current.attack()
		yield(current, "done")
	emit_signal("attack_finished")
	attacking = false