extends Node2D
class_name WaveComponent

@export var Waves = [] 
var counter = 0
var testing
var margin = 8
var screeen_width = ProjectSettings.get_setting("display/window/size/viewport_width")

@onready var spawner_component = $SpawnerComponent
@onready var starttimer = $GreenEnemyTimer



func _ready():
	starttimer.timeout.connect(handle_spawn.bind(Waves[counter], starttimer))
	

func handle_spawn(enemy_scene: PackedScene, _timer):
	
	spawner_component.scene = enemy_scene
	testing = spawner_component.spawn(Vector2(screeen_width, -16))
	testing.waveend.connect(next_wave)
	
	
	#timer.start()
	
func next_wave ():
	starttimer.timeout.disconnect(handle_spawn.bind(Waves[counter], starttimer))
	if counter < (len(Waves)-1):
		counter += 1
	else:
		print("OUTOFWAVES")
	print(counter)
	starttimer.timeout.connect(handle_spawn.bind(Waves[counter], starttimer))
	starttimer.start()
	print("Waveended")
