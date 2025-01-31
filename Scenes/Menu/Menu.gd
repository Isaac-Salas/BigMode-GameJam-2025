extends Control
class_name Menu
@onready var animation_player = $ColorRect/AnimationPlayer
@onready var color_rect = $ColorRect
@export var Player : PlayerComponent
@onready var spawner_component = $SpawnerComponent
@export var world : Node2D
@onready var control = $"."


# Called when the node enters the scene tree for the first time.
func _ready():
	color_rect.visible = true
	#animation_player.play("new_animation")
	

func _physics_process(_delta):
	match Player.shooting:
		true:
			spawner_component.spawn(control.global_position, self.get_parent())
			self.queue_free()
		false:
			pass

	match Player.eating:
		true:
			spawner_component.spawn(control.global_position, self.get_parent())
			self.queue_free()

		false:
			pass
	
	match Player.punching:
		true:
			pass
	
