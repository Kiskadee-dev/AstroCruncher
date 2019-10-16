extends TextureProgress

onready var tween = $Tween
onready var damage = $DamageFollow

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func decrease_life(new_value:float):
	tween.stop_all()
	tween.interpolate_property(self, "value", value, new_value, 1, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	tween.start()
	yield(tween, "tween_completed")
	damage.decrease_life(new_value)
	
func set_life(value:float):
	pass
