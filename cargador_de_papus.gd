extends Node2D
const REALLEVEL = preload("res://Scenes/Levels/Snake-Level/Reallevel.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var children = get_child_count()
	if children == 0:
		print("Ass")
	print(children)


func _on_timer_timeout():
	get_tree().change_scene_to_packed(REALLEVEL)
	
