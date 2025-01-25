extends Node2D
@onready var head = $Head
@onready var segment = $Segment
@onready var tail = $Tail
@onready var timer = $Timer
@onready var previous
@onready var pieces : Array
@onready var currentdir : Vector2
@onready var previoushead : Vector2
@onready var prevsegment
# Called when the node enters the scene tree for the first time.
func _ready():
	for i in self.get_children():
		pieces.append(i)
	print(pieces)
	currentdir =  Vector2(1,0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):

	if Input.is_action_just_pressed("ui_left"):
		currentdir =  Vector2(-1,0)
	if Input.is_action_just_pressed("ui_right"):
		currentdir =  Vector2(1,0)
	if Input.is_action_just_pressed("ui_up"):
		currentdir =  Vector2(0,-1)
	if Input.is_action_just_pressed("ui_down"):
		currentdir =  Vector2(0,1)
		

func _on_timer_timeout():
	previoushead = head.position
	head.position += currentdir * 16
	for i in pieces:
		if i is SegmentSnake:
			if i.index == 0:
				i.position = previoushead
				prevsegment = i
				#prevsegment.previouspos = prevsegment.position
				#print(prevsegment)
			elif i.index != 0:
				
				print (prevsegment)
				i.position = prevsegment.previouspos
				print(prevsegment.previouspos)
				prevsegment = i
				#prevsegment.previouspos = prevsegment.position
				#
				#prevsegment = i
				
				
