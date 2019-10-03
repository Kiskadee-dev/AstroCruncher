extends Node

var movement_vector:Vector2 = Vector2()
signal shoot
signal stopshooting

func _input(event):
	movement_vector = Vector2()
	event = event as InputEvent
	if Input.is_action_pressed("cima"):
		movement_vector.y -= 1
	if Input.is_action_pressed("baixo"):
		movement_vector.y += 1
	if Input.is_action_pressed("direita"):
		movement_vector.x += 1
	if Input.is_action_pressed("esquerda"):
		movement_vector.x -= 1
	if event.is_action_pressed("shoot"):
		emit_signal("shoot")
	if event.is_action_released("shoot"):
		emit_signal("stopshooting")
