extends AnimatedSprite2D
@onready var upper_layer = $UpperLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	play("default")
	upper_layer.play("default")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
