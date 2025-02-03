extends Node2D
class_name LoadingScreen
@onready var progress = []
@export var ScenePath : String 
@onready var scene_status = 0
@onready var progress_bar = $ProgressBar
@onready var loading = $Loading

@onready var timer = $Timer
@onready var thing : bool
@onready var newScene


# Called when the node enters the scene tree for the first time.
func _ready():
	ResourceLoader.load_threaded_request(ScenePath)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	loading.scale += Vector2(0.001,0.001)
	scene_status = ResourceLoader.load_threaded_get_status(ScenePath,progress)
	progress_bar.value = floor(progress[0]*100)
	if scene_status == ResourceLoader.THREAD_LOAD_LOADED:
		if timer.timeout:
			newScene = ResourceLoader.load_threaded_get(ScenePath)
			thing = true
	
	match thing:
		false:
			print(timer.wait_time)
			pass
		true:
			timer.start(2)
			thing = false

func _on_timer_timeout():
	get_tree().change_scene_to_packed(newScene)
