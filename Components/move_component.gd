class_name MoveComponent
extends Node
@export var actor : Node2D
@export var velocity : Vector2
@export var active = true
@export var rotation = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match active:
		true:
			actor.rotation_degrees += rotation
			actor.translate(velocity*delta)
		false:
			pass
	
