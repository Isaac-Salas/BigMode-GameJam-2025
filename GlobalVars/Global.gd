extends Node
@onready var currentsong
@onready var lastplace
@onready var shader : String
@onready var allthefruit : int = 0
@onready var allthealiens : int = 0

var ending = "bad"
var game = "puyo"

var papu_transitioner = preload("res://Scenes/LoadingScreens/transition.tscn")
var transition
	
func spawn_scene(parent: Node):
	transition = papu_transitioner.instantiate()
	parent.add_child(transition)
	return true

func transition_into(parent: SceneTree):
	await transition.opening(parent)
	transition.queue_free()
	return true
	
func transition_out_of(parent: SceneTree):
	await transition.closing(parent)
	transition.queue_free()
	return true
