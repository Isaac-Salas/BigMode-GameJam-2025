extends Node2D
class_name FullSnake
@onready var head = $Head
@onready var segment = $Segment
@onready var tail = $Tail
@onready var timer = $Timer
@onready var smooth : bool = false
@onready var previous
@onready var pieces : Array
@onready var snakesize : int
@onready var currentdir : Vector2
@onready var previoushead : Vector2
@onready var prevsegment
@onready var selectedpiece : int = 1 
@onready var starturning: bool = false
@onready var comparison 
@onready var segments
@onready var score : int
#@onready var shake_component = $ShakeComponent
@onready var scale_component : ScaleComponent = $"../HUD/ScaleComponent"
@onready var ownscale = $ScaleComponent
@onready var eaten_stuff = $"../HUD/EatenStuff"
@onready var area_2d = $Head/Area2D

@onready var particles : GPUParticles2D = $Head/CrumbsFruit
@onready var allthefruit : Array[RigidBody2D]
@export var fruitvel : int = 50
@export var spawner : Marker2D
@export var portrait : Portrait_Snake
@onready var bones : GPUParticles2D= $Head/Bones
@onready var blood : GPUParticles2D= $Head/Blood
@onready var borde = $"../HUD/Borde"
@onready var piedrotas = $Head/Piedrotas
@onready var label = $Label
@export var wincammarker : Marker2D 
@onready var secondary = $Secondary

@onready var chewing = $Chewing
@export var winplayer : AnimationPlayer
const SNAKE_LOAD = preload("res://Scenes/LoadingScreens/SnakeLoad.tscn")
const CRUNCH = preload("res://Assets/SFX/Snake/Crunch.wav")
const EVIL = preload("res://Assets/SFX/Snake/Evil.wav")
const HAPPY = preload("res://Assets/SFX/Snake/Happy.wav")
const SCREAM = preload("res://Assets/SFX/Snake/Scream.wav")
const RICK = preload("res://Assets/SFX/Snake/Rick.wav")
const SNAKE_SCORE = preload("res://Scenes/LoadingScreens/SnakeScore.tscn")
const SEGMENT = preload("res://Scenes/Levels/Snake-Level/Segment/segment.tscn")
const KIWI = preload("res://Assets/Sprites/Portraits/Fruit_Kiwi.png")
const MANZANAI = preload("res://Assets/Sprites/Portraits/Fruit_Manzanai.png")
const NARANJAI = preload("res://Assets/Sprites/Portraits/Fruit_Naranjai.png")
@onready var movingcooldown = $Movingcooldown

@export var camera : Camera2D 


# Called when the node enters the scene tree for the first time.
func _ready():
	head.play("default")
	for i in self.get_children():
		pieces.append(i)
	#print(pieces)
	currentdir =  Vector2(1,0)
	snakesize = pieces.size()
	segments = pieces[selectedpiece]
	score = snakesize - 8
	comparison = head.position - previoushead


# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _process(delta):
	label.text = str(score)
	head.global_position.x = clamp(head.global_position.x,128,640)
	head.global_position.y =clamp(head.global_position.y,0,480)
	#print(head.global_position)


@warning_ignore("unused_parameter")
func _input(event):
	#print(allthefruit)
	if Input.is_action_just_pressed("ui_left"):
		if currentdir != Vector2(1,0) and currentdir != Vector2(-1,0):
			currentdir =  Vector2(-1,0)
			starturning = true
			head.rotation_degrees = 0
			head.rotation_degrees = -180
		if allthefruit != null:
				for i in allthefruit:
					if i != null:
						i.linear_velocity -= (currentdir*fruitvel)
	
	if Input.is_action_just_pressed("ui_right") and currentdir != Vector2(1,0):
		if currentdir != Vector2(-1,0):
			currentdir =  Vector2(1,0)
			starturning = true
			head.rotation_degrees = 0
		if allthefruit != null:
				for i in allthefruit:
					if i != null:
						i.linear_velocity -= (currentdir*fruitvel)
	if Input.is_action_just_pressed("ui_up") and currentdir != Vector2(0,-1):
		if currentdir != Vector2(0,1):
			currentdir =  Vector2(0,-1)
			starturning = true
			head.rotation_degrees = -90
		if allthefruit != null:
				for i in allthefruit:
					if i != null:
						i.linear_velocity -= (currentdir*fruitvel)
	if Input.is_action_just_pressed("ui_down")and currentdir != Vector2(0,1):
		if currentdir != Vector2(0,-1):
			currentdir =  Vector2(0,1)
			starturning = true
			head.rotation_degrees = 90
		if allthefruit != null:
				for i in allthefruit:
					if i != null:
						i.linear_velocity -= (currentdir*fruitvel)
		

func _on_timer_timeout():
	comparison = head.position - previoushead
	segments = pieces[selectedpiece]
	await movingcooldown.timeout
	#print(head.position, previoushead)
	#print(comparison,currentdir) 
	#print(segments)
	#print(starturning)
	match starturning:
		true:
			
			match currentdir:
				Vector2(-1,0): #Izquierda 
					segments = pieces[1]
					segments.play("Always")
					#portrait.position.x -= 5
				Vector2(1,0):
					segments = pieces[1]
					segments.play("Always")
					#portrait.position.x += 5
				Vector2(0,-1): #Arriba
					segments = pieces[1]
					segments.play("Always")
					#portrait.position.y -= 5
					
				Vector2(0,1): #Abajo
					segments = pieces[1]
					segments.play("Always")
					#portrait.position.y += 5
			
			if selectedpiece < score :
				if score == 1:
					starturning = false
				else:
					selectedpiece +=1
			else:
				selectedpiece = 1
				starturning = false
				
				
		false:
			
			for i in pieces:
				if i != null and i is SegmentSnake:
					i.play("Always")
							
				elif i != null and i.is_in_group("Tail"):
					i.rotation_degrees = head.rotation_degrees
			
	
	
	
	#print(selectedpiece)
	
	previoushead = head.position
	head.position += currentdir * 16
	
	for i in pieces:
		
		if i != null and i is SegmentSnake:
			#print(i.tracking)
			if i.index == 0:
				i.previouspos = i.position
				i.position = previoushead
				i.tracking = head
				#print(i.position, i.previouspos)
				prevsegment = i
				#print(prevsegment)
			elif i.index != 0:
				#print(i)
				i.previouspos = i.position
				i.tracking = prevsegment
				i.position = prevsegment.previouspos
				prevsegment = i
		
		if i != null and i.is_in_group("Tail"):
			tail.position = prevsegment.previouspos
			#print(tail.position)
			
func add_segment(sibling : Node2D, num_pieces : int) :
	print("adding segment", num_pieces)
	for num in num_pieces:
		score += 1
		var newsegment : SegmentSnake = SEGMENT.instantiate()
		newsegment.index = score-1
		newsegment.position = segment.position
		sibling.add_sibling(newsegment)
		#sibling.call_deferred("add_sibling", newsegment)
		
		
	#Aqui refrescame el ass
	pieces = []
	for i in self.get_children():
		pieces.append(i)

	snakesize = pieces.size()
	segments = pieces[selectedpiece]
	timer.wait_time -= 0.0008
	movingcooldown.wait_time -= 0.0008
	
	
func remove_segment(num_pieces : int , body : Node2D ) :
	for num in num_pieces:
		for i in pieces:
			if i != null and i is SegmentSnake:
				if i.index == score-1:
					i.queue_free()
		score -= 1
	#Aqui refrescame el ass
	body.queue_free()
	pieces = []
	for i in self.get_children():
		pieces.append(i)
	snakesize = pieces.size()
	segments = pieces[selectedpiece]
	timer.wait_time += 0.0008
	movingcooldown.wait_time += 0.0008
	allthefruit.pop_back().queue_free()
	

func win():
	timer.stop()
	ownscale.scale_amount = Vector2(0,0)
	ownscale.tween_scale()
	camera.global_position = wincammarker.global_position
	#Global.alltheshit = allthefruit
	for i in allthefruit:
		if i is Fruit:
			Global.allthefruit += 1
		if i is Alien:
			Global.allthealiens += 1 
	winplayer.play("Megafade")
	await winplayer.animation_finished
	if Global.allthefruit > Global.allthealiens:
		Global.ending = "good"
	else:
		Global.ending = "bad"
	Global.game = "snake"
	get_tree().change_scene_to_packed(SNAKE_SCORE)
	
		
	

func die():
	timer.stop()
	ownscale.scale_amount = Vector2(0,0)
	ownscale.tween_scale()
	#camera.zoom = 3

@warning_ignore("shadowed_variable")
func eat(body : RigidBody2D, spawner : Marker2D):
	body.position = spawner.position
	body.z_index = 0
	#body.call_deferred("reparent", eaten_stuff)
	#body.reparent(eaten_stuff)
	body.set_deferred("freeze", false)
	body.add_constant_force(Vector2(randi_range(-20,20),0))
	allthefruit.append(body)
	print(allthefruit)


func _on_area_2d_body_entered(body):
	if body.is_in_group("Segment"):
		die()
	elif body is Fruit and body != null:
		chewing.stream = CRUNCH
		chewing.pitch_scale = randf_range(1,3)
		chewing.play()
		particles.restart()
		body.burbujes.emitting = true
		particles.emitting = true
		portrait.choose_emotion(portrait.CARA_FELIZ)
		ownscale.tween_scale()
		scale_component.tween_scale()
		add_segment(segment,body.value)
		eat(body,spawner)
		if score >= 65:
			win()
	elif body is Alien:
		chewing.stream = CRUNCH
		chewing.pitch_scale = randf_range(1,3)
		chewing.play()
		secondary.stream = SCREAM
		secondary.pitch_scale = randf_range(1,3)
		secondary.play()
		blood.restart()
		bones.restart()
		blood.emitting = true
		bones.emitting = true
		body.die()
		portrait.choose_emotion(portrait.CARA_ENOJADA)
		ownscale.tween_scale()
		scale_component.tween_scale()
		add_segment(segment,body.value)
		eat(body,spawner)
	elif body.is_in_group("Wall"):
		if score != 1:
			chewing.stream = CRUNCH
			chewing.pitch_scale = randf_range(1,3)
			chewing.play()
			secondary.stream = RICK
			secondary.pitch_scale = randf_range(1,3)
			secondary.play()
			area_2d.monitoring = false
			ownscale.tween_scale()
			area_2d.monitoring = true
			piedrotas.restart()
			piedrotas.emitting = true
			remove_segment(1, body)
			
		else:
			die()
		


	
