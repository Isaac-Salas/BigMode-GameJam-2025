extends Node2D
class_name FullSnake
@onready var head = $Head
@onready var segment = $Segment
@onready var tail = $Tail
@onready var timer = $Timer

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
const SEGMENT = preload("res://Scenes/Levels/Snake-Level/Segment/segment.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	for i in self.get_children():
		pieces.append(i)
	#print(pieces)
	currentdir =  Vector2(1,0)
	snakesize = pieces.size()
	segments = pieces[selectedpiece]
	score = snakesize - 3
	comparison = head.position - previoushead


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _unhandled_input(event):
	
	if Input.is_action_just_pressed("ui_left"):
		if currentdir != Vector2(1,0) and currentdir != Vector2(-1,0):
			currentdir =  Vector2(-1,0)
			starturning = true
			head.rotation_degrees = 0
			head.rotation_degrees = -180
	if Input.is_action_just_pressed("ui_right") and currentdir != Vector2(1,0):
		if currentdir != Vector2(-1,0):
			currentdir =  Vector2(1,0)
			starturning = true
			head.rotation_degrees = 0
	if Input.is_action_just_pressed("ui_up") and currentdir != Vector2(0,-1):
		if currentdir != Vector2(0,1):
			currentdir =  Vector2(0,-1)
			starturning = true
			head.rotation_degrees = -90
	if Input.is_action_just_pressed("ui_down")and currentdir != Vector2(0,1):
		if currentdir != Vector2(0,-1):
			currentdir =  Vector2(0,1)
			starturning = true
			head.rotation_degrees = 90
		

func _on_timer_timeout():
	comparison = head.position - previoushead
	segments = pieces[selectedpiece]
	print(comparison,currentdir) 
	print(segments)
	#print(starturning)
	match starturning:
		true:
			
			match currentdir:
				Vector2(-1,0): #Izquierda 
					segments = pieces[1]
					segments.play("Always")
				Vector2(1,0):
					segments = pieces[1]
					segments.play("Always")
				Vector2(0,-1): #Arriba
					segments = pieces[1]
					segments.play("Always")
						
					
				Vector2(0,1): #Abajo
					segments = pieces[1]
					segments.play("Always")
			
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
				if i is SegmentSnake:
					i.play("Always")
							
				elif i.is_in_group("Tail"):
					i.rotation_degrees = head.rotation_degrees
			
	
	
	
	#print(selectedpiece)
	
	previoushead = head.position
	head.position += currentdir * 16
	
	for i in pieces:
		
		if i is SegmentSnake:
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
		
		if i.is_in_group("Tail"):
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
	

func die():
	queue_free()

func _on_area_2d_body_entered(body):
	if body.is_in_group("Pared") or body.is_in_group("Segment"):
		die()
	elif body is Fruit:
		add_segment(segment,body.value)
		body.queue_free()
