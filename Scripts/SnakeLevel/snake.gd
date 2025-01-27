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
					segments.play("Idle_right")
				Vector2(1,0):
					pass
				Vector2(0,-1): #Arriba
					if comparison.x < 0: #Arriba moviendose a la Izq
						segments = pieces[1]
						segments.play("Turn_Up_left")
					elif comparison.x > 0: #Arriba moviendose a la der
						segments = pieces[1]
						segments.play("Turn_Up_right")
					elif comparison.x == 0:
						if selectedpiece > 1:
							var modsegment = pieces[selectedpiece-1]
							modsegment.stop()
							modsegment.play("Idle_up")
							print("Cambiando para arriba")
						
					
				Vector2(0,1): #Abajo
					if comparison.x < 0: #Abajo moviendose a la Izq
						segments = pieces[1]
						segments.play("Turn_Down_left")
					elif comparison.x > 0: #Abajo moviendose a la der
						segments = pieces[1]
						segments.play("Turn_Down_right")
					elif comparison.x == 0:
						if selectedpiece > 1:
							var modsegment = pieces[selectedpiece-1]
							modsegment.stop()
							modsegment.play("Idle_down")
							print("Cambiando para arriba")
			
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
					match currentdir:
						Vector2(-1,0):
							i.play("Idle_left")
						Vector2(1,0):
							i.play("Idle_right")
						Vector2(0,-1): #Arriba
							i.play("Idle_up")
						Vector2(0,1):
							i.play("Idle_down")
							
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
		newsegment.position = sibling.position
		sibling.add_sibling(newsegment)
		
	
	#Aqui refrescame el ass
	pieces = []
	for i in self.get_children():
		pieces.append(i)
	snakesize = pieces.size()
	segments = pieces[selectedpiece]
func die():
	queue_free()

func _on_area_2d_body_entered(body):
	if body.is_in_group("Pared"):
		die()
	elif body is Fruit:
		add_segment(segment,body.value)
		body.queue_free()
