class_name BarcoInputComponent
extends Node

@export var move_stats : MoveStats
@export var move_component : MoveComponent

func _input(event):
	#var input_axisy = Input.get_axis("ui_up","ui_down")
	var input_axisx = Input.get_axis("ui_left","ui_right")
	move_component.velocity = Vector2(input_axisx*move_stats.speed,0)
	
