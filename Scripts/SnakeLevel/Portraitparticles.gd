extends Sprite2D
class_name Portrait_Snake
@onready var particles : GPUParticles2D = $GPUParticles2D
const KIWI = preload("res://Assets/Sprites/Portraits/Fruit_Kiwi.png")
const MANZANAI = preload("res://Assets/Sprites/Portraits/Fruit_Manzanai.png")
const NARANJAI = preload("res://Assets/Sprites/Portraits/Fruit_Naranjai.png")

func choose_fruit(fruit):
	particles.texture = fruit
	particles.restart()
	particles.emitting = true
