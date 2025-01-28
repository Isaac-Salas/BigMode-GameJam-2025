extends RigidBody2D
class_name Aliens
@onready var moving : bool = false
@onready var monitos = $Monitos

func _ready():
	monitos.play("Idle")


func run():
	monitos.play("Run")
	
func scare():
	monitos.play("Scare")
