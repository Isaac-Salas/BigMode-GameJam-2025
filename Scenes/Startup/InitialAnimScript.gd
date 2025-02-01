extends Control
@onready var piggy = $Piggy
@onready var animation_player = $AnimationPlayer
@onready var dialog_box :DialogComponen = $DialogBox
const _1 = preload("res://Assets/Music/1.wav")
const _2 = preload("res://Assets/Music/2.wav")
const _3 = preload("res://Assets/Music/3.wav")
const _4 = preload("res://Assets/Music/4.wav")
const _5 = preload("res://Assets/Music/5.wav")
const LASTTHING = preload("res://Assets/Music/Lastthing.wav")
const MENU_LOAD = preload("res://Scenes/LoadingScreens/MenuLoad.tscn")


@onready var cosa = $Options/Cosa

@onready var audio_stream_player= $AudioStreamPlayer2D

@onready var point_light_2d = $PointLight2D
@onready var planetas = $Planetas
@onready var logo = $Logo
@onready var play = $Play
@onready var options = $Options
@onready var quit = $Quit
@onready var odgo_player = $OdgoPlayer
@onready var odgo = $ODGO

func _ready():
	audio_stream_player.stream = _1
	audio_stream_player.play()
	piggy.play("default")
	animation_player.play("Come_in")

func _process(delta):
	var mouse = get_global_mouse_position()
	point_light_2d.global_position = mouse
	
	if dialog_box != null:
		match dialog_box.linecount:
			0:
				pass
			1:
				dialog_box.theme.default_font_size = 64
			2:
				dialog_box.theme.default_font_size = 128*2
				dialog_box.push_color(Color.INDIAN_RED)
			3:
				dialog_box.theme.default_font_size = 64




func _on_animation_player_animation_finished(anim_name):
	print(anim_name)
	match anim_name:
		"Come_in":
			animation_player.play("Hover")
			dialog_box.InputEnable = true
			dialog_box.InputSTOP = false
			dialog_box.timer.start()
		"Hover":
			pass

func _on_audio_stream_player_2d_finished():
	if audio_stream_player.stream == LASTTHING:
		pass
	else:
		print(audio_stream_player.stream)
		audio_stream_player.play()


func _on_dialog_box_done():
	print("done")
	print(dialog_box.linecount)
	if dialog_box != null:
		match dialog_box.linecount:
			
			0: 
				#await audio_stream_player.finished
				audio_stream_player.stream = _2
				audio_stream_player.play()
				
				
			
			1:
				
			
				await audio_stream_player.finished
				#audio_stream_player.stream = _3
				audio_stream_player.play()
			2:
				await audio_stream_player
				#await audio_stream_player.finished
				audio_stream_player.stream = _4
				audio_stream_player.play()
				odgo.visible = true
				odgo_player.play("Odgocome")
				
				
			3:
				odgo_player.play_backwards("Odgocome")
				await odgo_player.animation_finished
				odgo.visible = false
				odgo_player.play("Planetas")
			4:
				odgo_player.play_backwards("Planetas")
				
				
			8:
				await audio_stream_player.finished
				audio_stream_player.stream = LASTTHING
				audio_stream_player.play()
				planetas.start = true
				animation_player.play("Go_out")
				planetas.visible = true
				logo.visible = true
				play.visible = true
				options.visible = true
				quit.visible = true
				
				
			9:
				await audio_stream_player.finished
				dialog_box.queue_free()
				
				
				




func _on_play_pressed():
	get_tree().change_scene_to_packed(MENU_LOAD)




func _on_quit_pressed():
	get_tree().quit()
