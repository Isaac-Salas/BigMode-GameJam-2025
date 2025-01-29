extends RigidBody2D
class_name Fruit
@export var value = 0
@onready var ogpos : Vector2

@onready var burbuji_as : GPUParticles2D = $"Burbujiñas"

func _ready():
	ogpos = position
	set_deferred("freeze",true)
	

func eaten():
	#particles.emitting = true
	pass
