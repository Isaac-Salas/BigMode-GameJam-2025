extends Node2D

@export var EnemyGen : WaveComponent
@export var Play = false
@onready var control = $Control/Control
@onready var player = $Player
@onready var start_timer = $StartTimer
@onready var game_over = false
@onready var intro_songs = $IntroSongs
@onready var fader = $IntroSongs/Fader
@onready var ingame = $Ingame
@onready var secondfader = $Ingame/Secondfader
@onready var menumode = true
@onready var creditrigger = $Creditos/Creditrigger
@onready var creditos = $Creditos
@onready var ui = $UI




# Called when the node enters the scene tree for the first time.
func _ready():
	ingame.finished.connect(looping)
	
	if Global.currentsong == null:
		nextone()
	else:
		intro_songs.finished.connect(nextone)
		intro_songs.stream = Global.currentsong
		intro_songs.play(Global.lastplace)
	
	fader.play("Fadein")
	player.tree_exiting.connect(gameover)
	control.animation_player.play("new_animation")
	#control.child_order_changed.connect(toggle)
func looping():
	ingame.stream = load("res://SHMUP/assets/Music/Ingame2.mp3")
	ingame.stream.loop = true
	ingame.play()
func nextone():
	intro_songs.stream = load("res://SHMUP/assets/Music/Intro2.mp3")
	intro_songs.stream.loop = true
	intro_songs.play()

	

func toggle():
	if player != null:
	
		match player.shooting:
			true:
				match menumode:
					true:
						ui.visible = true
						player.o2down()
						menumode = false
						creditos.queue_free()
						fader.play("Fadeout")
						await fader.animation_finished
						intro_songs.stop()
						ingame.stream = load("res://SHMUP/assets/Music/Ingame1.mp3").duplicate()
						ingame.play()
						start_timer.start(2)
						await start_timer.timeout
						start_timer.queue_free()
						Play = true
						
		match player.punching:
			true:
				match menumode:
					true:
						get_tree().quit()

		match player.eating:
			true:
				match menumode:
					true:
						creditos.visible = true
						creditrigger.play("Credits")
						menumode = false
						creditrigger.animation_finished
						await creditrigger.animation_finished
						get_tree().change_scene_to_file("res://SHMUP/scenes/world.tscn")
						


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	toggle()
	
	if Input.is_action_just_pressed("ui_shoot") and game_over == true:
		get_tree().change_scene_to_file("res://SHMUP/scenes/world.tscn")
	else:
		pass
	
	match Play:
		true:
			EnemyGen.starttimer.start()
			Play = false
		false:
			pass

	
func gameover():
	game_over = true
	
