extends Node2D

@onready var animation_player = $HUD/Borde/Portrait/AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	animation_player.play("new_animation")


func _input(event):
	if Input.is_action_just_pressed("Reset"):
		get_tree().reload_current_scene()
