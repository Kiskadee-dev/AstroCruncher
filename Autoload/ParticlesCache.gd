extends CanvasLayer

const particle_materials = [
	preload("res://Art/Particle materials/explosion_bullet.material"),
	preload("res://Art/Particle materials/explosion_bullet_player_damage.material")
]
func _ready():
	for i in particle_materials:
		var p = Particles2D.new()
		p.set_process_material(i)
		p.set_one_shot(true)
		p.set_emitting(true)
		add_child(p)
