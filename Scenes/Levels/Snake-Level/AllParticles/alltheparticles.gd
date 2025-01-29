extends Node2D
@onready var timer = $Timer
const NODE_2D = preload("res://Scenes/Levels/Snake-Level/node_2d.tscn")
@onready var all : Array

const BLOODPART = "res://Scenes/Levels/Snake-Level/Fruit/Bloodpart.tres"
const BONES = "res://Scenes/Levels/Snake-Level/Fruit/Bones.tres"
const FRUIT_TEMP = "res://Scenes/Levels/Snake-Level/Fruit/FruitTemp.tres"
const GORE = "res://Scenes/Levels/Snake-Level/Fruit/Gore.tres"
const MANZANAPARTICLES = "res://Scenes/Levels/Snake-Level/Fruit/manzanaparticles.tres"
const HAPPY_ORSAD = "res://Scenes/Levels/Snake-Level/Snake/HappyOrsad.tres"
const PUYO_LARGE_PORTRAIT = "res://PUYO/puyo_large_portrait.gdshader"
const FRUIT_TEMPSH = "res://Scenes/Levels/Snake-Level/Fruit/FruitTemp.gdshader"
const SNAKE = "res://Scenes/Levels/Snake-Level/Snake/snake.gdshader"

@onready var list : Array = [BLOODPART, BONES, FRUIT_TEMP,GORE, MANZANAPARTICLES, HAPPY_ORSAD,PUYO_LARGE_PORTRAIT, FRUIT_TEMPSH, SNAKE]
# Called when the node enters the scene tree for the first time.
func _ready():
	for i in list:
		var ass = ResourceLoader.load_threaded_request(i)
		var enemy_scene = ResourceLoader.load_threaded_get(i)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_timer_timeout():
	queue_free()
