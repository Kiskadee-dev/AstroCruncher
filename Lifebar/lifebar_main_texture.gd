extends TextureProgress

onready var tween = $Tween
onready var damage = $DamageFollow

func decrease_life(new_value:float):
	tween.stop_all()
	tween.interpolate_property(self, "value", value, new_value, 1, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	tween.start()
	yield(tween, "tween_completed")
	damage.decrease_life(new_value)
	
func set_life(value:float):
	pass
