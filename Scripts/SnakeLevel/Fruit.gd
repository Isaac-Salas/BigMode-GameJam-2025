extends RigidBody2D
class_name Fruit
@export var value = 0
@onready var ogpos : Vector2
@onready var particles : GPUParticles2D = $GPUParticles2D

func _ready():
	ogpos = position
	set_deferred("freeze",true)
	

func eaten():
	particles.global_position = ogpos
	particles.emitting = true
