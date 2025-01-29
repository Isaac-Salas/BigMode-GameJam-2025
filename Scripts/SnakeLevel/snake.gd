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
@onready var scale_component = $ScaleComponent
@onready var particles : GPUParticles2D = $Head/CrumbsFruit
@onready var allthefruit : Array[RigidBody2D]
@export var fruitvel : int = 50
@export var spawner : Marker2D
@export var portrait : Portrait_Snake
@onready var bones : GPUParticles2D= $Head/Bones
@onready var blood : GPUParticles2D= $Head/Blood


const SEGMENT = preload("res://Scenes/Levels/Snake-Level/Segment/segment.tscn")
const KIWI = preload("res://Assets/Sprites/Portraits/Fruit_Kiwi.png")
const MANZANAI = preload("res://Assets/Sprites/Portraits/Fruit_Manzanai.png")
const NARANJAI = preload("res://Assets/Sprites/Portraits/Fruit_Naranjai.png")


# Called when the node enters the scene tree for the first time.
func _ready():
	head.play("default")
	for i in self.get_children():
		pieces.append(i)
	#print(pieces)
	currentdir =  Vector2(1,0)
	snakesize = pieces.size()
	segments = pieces[selectedpiece]
	score = snakesize - 4
	comparison = head.position - previoushead


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func _unhandled_input(event):
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
	

func die():
	queue_free()

func eat(body : RigidBody2D, spawner : Marker2D):
	body.position = spawner.position
	#body.call_deferred("reparent",spawner,true)
	body.set_deferred("freeze", false)
	body.add_constant_force(Vector2(randi_range(-20,20),0))
	allthefruit.append(body)


func _on_area_2d_body_entered(body):
	if body.is_in_group("Segment"):
		die()
	elif body is Fruit:
		particles.restart()
		particles.emitting = true
		#body.burbuji_as.emitting = true
		portrait.choose_emotion(portrait.CARA_FELIZ)
		scale_component.tween_scale()
		add_segment(segment,body.value)
		eat(body,spawner)
	elif body is Alien:
		blood.restart()
		bones.restart()
		blood.emitting = true
		bones.emitting = true
		body.die()
		portrait.choose_emotion(portrait.CARA_ENOJADA)
		scale_component.tween_scale()
		add_segment(segment,body.value)
		eat(body,spawner)
	elif body.is_in_group("Wall"):
		if score != 1:
			remove_segment(1, body)
		else:
			die()
		
