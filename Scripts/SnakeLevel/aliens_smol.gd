extends RigidBody2D
class_name Alien
const MANZANA_REAL = preload("res://Scenes/Levels/Snake-Level/Fruit/ManzanaReal.tscn")
const KIWI = preload("res://Scenes/Levels/Snake-Level/Fruit/Kiwi.tscn")
const NARANJA = preload("res://Scenes/Levels/Snake-Level/Fruit/Naranja.tscn")
@onready var spawner_component = $SpawnerComponent
@onready var monitos = $Monitos
@onready var luz_falsa = $LuzFalsa
@onready var fruits : Array = [MANZANA_REAL,KIWI,NARANJA]
@onready var directionx : int
@onready var directiony : int
@onready var spawner_time = $SpawnerTime
@onready var dirlist : Array = ["X", "Y"]
@onready var selected : String


@export var value = 1
@onready var gore = $Gore
@onready var run_timer = $RunTimer
@onready var alive : bool = true
@onready var area_2d = $Area2D

@onready var burbuji_as = $"Burbujiñas"


# Called when the node enters the scene tree for the first time.
func _ready():
	#spawner_time.start(randf_range(1,10))
	var NEWcolor = Color(randf_range(0,1),randf_range(0,1),randf_range(0,1))
	luz_falsa.modulate = Color(NEWcolor.r, NEWcolor.g, NEWcolor.b, 0.196078431372549)
	monitos.modulate = NEWcolor
	monitos.play("Idle")
	spawner_component.scene = fruits[randi_range(0,2)]
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.


	
	

func die():
	monitos.stop()
	set_deferred("freeze",false)
	run_timer.stop()
	spawner_time.stop()
	monitos.play("Die")
	gore.set_deferred("visible",true)
	alive = false

	burbuji_as.emitting = true
	

func scare():
	monitos.play("Scare")
	await monitos.animation_looped
	spawner_time.start(randf_range(5,10))
	run()

func run():
	monitos.play("Run")
	run_timer.start(0.2)
	

func _on_run_timer_timeout():
	print("move")
	selected = dirlist[randi_range(0,1)]
	directionx = randi_range(-1,1)
	directiony = randi_range(-1,1)
	
	match alive:
		true:
			if directionx != null and directiony != null:
				match selected:
					"X":
						global_position.x += directionx*16
					"Y":
						global_position.y += directiony*16
		false:
			pass
	
	

func _on_spawner_time_timeout():
	spawner_component.spawn()


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func _on_area_2d_area_entered(area):
	if area.is_in_group("SnakeArea"):
		area_2d.queue_free()
		scare()
		
