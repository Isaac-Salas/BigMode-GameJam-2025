class_name MoveInputComponent
extends Node

@export var move_stats : MoveStats
@export var move_component : MoveComponent
@export var active = true

func _input(_event):
	
	match active:
		true:
			var input_axisy = Input.get_axis("ui_up","ui_down")
			var input_axisx = Input.get_axis("ui_left","ui_right")
			move_component.velocity = Vector2(input_axisx*move_stats.speed,input_axisy*move_stats.speed)
			
		false:
			pass
	
	
