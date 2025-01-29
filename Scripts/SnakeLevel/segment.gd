extends AnimatedSprite2D
class_name SegmentSnake
@onready var previouspos : Vector2
@export var index : int = 0
@onready var tracking


func eatturn():
	play("Eat-turn")
	
func turn():
	play("Turn")

func idle():
	play("Idle")
	
func eat():
	play("Eat")
