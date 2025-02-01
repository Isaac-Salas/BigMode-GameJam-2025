extends Sprite2D
class_name SlaveHut
@onready var timer = $Timer
@onready var spawner_component = $SpawnerComponent


# Called when the node enters the scene tree for the first time.
func _ready():
	modulate = Color(randf_range(.6,1), randf_range(.6,1), randf_range(.6,1))
	

func startspawn():
	timer.start(randf_range(5,15))

func _on_timer_timeout():
	spawner_component.spawn()
	timer.start(randf_range(5,15))
