extends Sprite2D
class_name Portrait_Snake
@onready var particles : GPUParticles2D = $GPUParticles2D
const CARA_FELIZ = preload("res://Assets/Sprites/SnakeLevel/CaraFeliz.png")
const CARA_ENOJADA = preload("res://Assets/Sprites/SnakeLevel/CaraEnojada.png")
const HAPPY_ORSAD = preload("res://Scenes/Levels/Snake-Level/Snake/HappyOrsad.tres")

@onready var scale_component = $ScaleComponent


func ready():
	self.global_position = Vector2(72,88)

func choose_emotion(emotion):
	scale_component.tween_scale()
	particles.texture = emotion
	particles.restart()
	particles.emitting = true
