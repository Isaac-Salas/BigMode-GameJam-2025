extends AnimatedSprite2D
class_name SegmentSnake
@onready var previouspos : Vector2
@export var index : int = 0

func _ready():
	previouspos = self.position
func eatturn(rotate):
	play("Eat-turn")
	
func turn():
	play("Turn")

func idle():
	play("Idle")
	
func eat():
	play("Eat")
