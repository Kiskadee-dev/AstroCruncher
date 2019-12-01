extends Node2D

onready var Asteroid = preload("res://Enemies/Asteroid.tscn")
onready var Enemy01 = preload("res://Enemies/Enemy01.tscn")
onready var Enemy02 = preload("res://Enemies/Enemy02.tscn")
var done:bool
var started:bool = false
var increment:bool = true
signal wave_finished(increment)

var repeated:int=0
var spawned:int=0
var spawn_quantity:int
var reapeat_times = 5

var max_position:Vector2
var min_position:Vector2
onready var screensize = get_viewport_rect().size

onready var cooldown_timer:Timer = Timer.new()

func _ready():
	randomize()
	get_viewport().connect("size_changed", self, "update_spawn")
	update_spawn()
	add_child(cooldown_timer)

func update_spawn():
	max_position = get_viewport().get_visible_rect().end
	max_position.y = 0
	min_position = get_viewport().get_visible_rect().end

func finished():
	repeated = 0
	spawned = 0
	started = false
	emit_signal("wave_finished", increment)

func start_wave():
	if started:
		printerr("The calls are overlapping")
	repeated = 0
	spawned = 0

func cleanup():
	queue_free()
