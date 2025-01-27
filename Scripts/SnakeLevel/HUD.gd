extends Control
@export var snake : FullSnake
@onready var score = $Score

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if snake:
		score.text = str(snake.score)
	
