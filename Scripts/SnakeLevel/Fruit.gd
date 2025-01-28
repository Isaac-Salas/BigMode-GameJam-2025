extends RigidBody2D
class_name Fruit
@export var value = 0
@onready var ogpos : Vector2
@onready var particles : CPUParticles2D = $GPUParticles2D
@onready var burbuji_as : CPUParticles2D = $"Burbujiñas"

func _ready():
	ogpos = position
	set_deferred("freeze",true)
	

func eaten():
	particles.global_position = ogpos
	particles.emitting = true
