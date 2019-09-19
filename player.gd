extends KinematicBody2D

var speed = 200
var movement_vector:Vector2
onready var inputs = $Inputs
var shoot = false
onready var sprite = $Sprite

var screensize
func _ready():
	screensize = get_viewport_rect().size

func _physics_process(delta):
	movement_vector = inputs.movement_vector
	move_and_slide(speed*movement_vector)
	if movement_vector.y > 0:
		sprite.play("dir")
	elif movement_vector.y < 0:
		sprite.play("esq")
	else:
		sprite.play("default")
	position.x = clamp(position.x, 100, screensize.x-5)
	position.y = clamp(position.y, 100, screensize.y-100)
func _on_Inputs_shoot():
	shoot = true

func _on_Inputs_stopshooting():
	shoot = false
