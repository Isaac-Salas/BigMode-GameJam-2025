extends Node2D
@onready var barquito = $Barcote/Barquito
@onready var animation_player = $AnimationPlayer
@onready var canstart = false
@onready var timer = $Timer
@onready var aguarriba = $Aguarriba
@onready var prota = $Prota
@onready var globo = $Prota/Globo
@onready var barcote = $Barcote
@onready var fondo = $Fondo
@onready var label = $Label
@onready var animation = ""
@onready var move_component = $Barcote/MoveComponent
@onready var aqua = $Objetillos/Aqua
@onready var s = $Objetillos/S
@onready var h = $Objetillos/H
@onready var m = $Objetillos/M
@onready var u = $Objetillos/U
@onready var b = $Objetillos/B
@onready var burbujas = $Objetillos/Burbujas
@onready var timer_2 = $TIMER2
@onready var bplayer = $Objetillos/B/AnimatedSprite2D
@onready var broto = $Objetillos/B/Piece/Broto
@onready var piece = $Objetillos/B/Piece
@onready var animation_player_2 = $Objetillos/B/Piece/AnimationPlayer2
@onready var camera_2d = $Camera2D
@onready var player_swim = $PlayerSwim
@onready var press_shoot = $"Objetillos/Press-Shoot"
@onready var intro_p_1 = $IntroMusic
@onready var fader = $IntroMusic/Fader

@onready var timer_p = $TimerP
@export var done = false

var img 
func _ready():
	#playnext()
	intro_p_1.finished.connect(playnext)

func _on_timer_timeout():
	animation_player.play("AppearText")
	timer.autostart = false
	timer.queue_free()
	canstart = true

func _input(event):
	if Input.is_anything_pressed():
		match canstart:
			false:
				pass
			true:
				if label != null:
					prota.animation_finished.connect(switching)
					animation_player.play("Shrink")
					#await prota.animation_looped
					label.queue_free()
					await barquito.animation_looped
					prota.play("new_animation")
					intro_p_1.stream = load("res://assets/Music/Intro1.mp3").duplicate()
					intro_p_1.stream
					intro_p_1.play()
					
					globo.visible = true
					globo.play("Dialogo")
					animation = "Chapuzon"
					canstart = false
				else:
					pass
					
	if Input.is_action_just_pressed("ui_shoot") and done == true:
		#img = get_viewport().get_texture().get_image()
		#img.save_png("res://assets/screenshots/fondo.png")
		#img.save_png_to_buffer()
		
		animation_player.play("CameraPull")
		move_component.active = false
		done = false
		canstart = false
		await animation_player.animation_finished
		player_swim.visible = true
		animation_player.play("CameraPull_2")
		player_swim.play("default")
		fader.play("Fadeout")
		await animation_player.animation_finished
		Global.lastplace = intro_p_1.get_playback_position()
		Global.currentsong = intro_p_1.stream
		
		get_tree().change_scene_to_file("res://scenes/world.tscn")
		#await img.save_png("res://assets/screenshots/fondo.png")
		#
			

func switching():
	prota.animation_finished.disconnect(switching)
	prota.animation_finished.connect(animate)
	prota.offset.x = 20
	prota.offset.y = -12
	aqua.set_deferred("freeze", false)
	s.set_deferred("freeze", false)
	u.set_deferred("freeze", false)
	b.set_deferred("freeze", false)
	timer_2.start(3)
	timer_2.timeout.connect(fall)
	var burbujeitors = burbujas.get_children()
	for i in burbujeitors:
		i.set_deferred("freeze", false)

	prota.play(animation)
	await prota.animation_finished
	prota.queue_free()
	#prota.animation_finished.disconnect(switching)
	
	
	
func fall():
	h.set_deferred("freeze", false)
	m.set_deferred("freeze", false)
	

func animate():
	pass

func playnext():
	intro_p_1.stream = load("res://assets/Music/Intro2.mp3").duplicate()
	intro_p_1.stream.loop = true
	intro_p_1.play()

func _on_area_2d_body_entered(body):
	if body.name ==  "M":
		move_component.active = true
		#s.lock_rotation = false
		#u.lock_rotation = false
		#b.lock_rotation = false
		timer_p.start(3)
		await timer_p.timeout
		bplayer.play("P")
		broto.play("default")
		await broto.animation_finished
		piece.set_deferred("freeze", false)
		piece.angular_velocity= 50
		animation_player_2.play("Dissapear")
		await animation_player_2.animation_finished
		press_shoot.set_deferred("freeze", false)
		done = true
		piece.queue_free()
