extends Node

signal health_updated

var health:float = 100

func damage(value:float):
	health -= value
	health = clamp(health, 0, 100)
	emit_signal("health_updated")