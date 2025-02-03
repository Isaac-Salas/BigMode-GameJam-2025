extends Node2D
@onready var music = $Music
const SNEK = preload("res://Assets/Music/Snek.mp3")
@onready var animation_player = $HUD/Borde/Portrait/AnimationPlayer
@onready var transition: Node2D = $Camera2D/transition

# Called when the node enters the scene tree for the first time.
func _ready():
	await transition.opening()
	animation_player.play("new_animation")
	music.stream = SNEK
	music.play()


func _input(event):
	if Input.is_action_just_pressed("Reset"):
		get_tree().reload_current_scene()


func _on_music_finished():
	music.play()
