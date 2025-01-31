
extends Node
class_name MoveGridComponent
@export var actor : Node2D
@export var velocity : Vector2
@export var timer : Timer
@export var active = true
@export var rotation = 0




func _on_timer_timeout():
	match active:
		true:
			actor.rotation_degrees += rotation
			actor.translate(velocity)
		false:
			pass
