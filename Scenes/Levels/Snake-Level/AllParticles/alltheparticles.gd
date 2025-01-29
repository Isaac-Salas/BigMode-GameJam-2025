extends Node2D
@onready var timer = $Timer
const NODE_2D = preload("res://Scenes/Levels/Snake-Level/node_2d.tscn")
@onready var all : Array
# Called when the node enters the scene tree for the first time.
func _ready():
	var all = get_children()
	for i in all:
		if i is GPUParticles2D:
			i.emitting = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_timer_timeout():
	get_tree().change_scene_to_packed(NODE_2D)
