extends Sprite2D
class_name Portrait_Snake
@onready var particles : CPUParticles2D = $GPUParticles2D
const CARA_FELIZ = preload("res://Assets/Sprites/SnakeLevel/CaraFeliz.png")
const CARA_ENOJADA = preload("res://Assets/Sprites/SnakeLevel/CaraEnojada.png")
@onready var shake_component = $ShakeComponent

func choose_emotion(emotion):
	
	particles.texture = emotion
	particles.restart()
	particles.emitting = true
