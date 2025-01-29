extends RichTextLabel
class_name DialogComponent
@export var InputEnable : bool = true
@export var InputSTOP : bool = false
@export var Timerstart : bool = false
@export var linecount : int = 0
@export var Typetime : float = 0
@export var Quickypetime : float = 0
@export var Dialog : PackedStringArray
@onready var extraevent : bool = true

@onready var charcount : int = 0
@onready var timer = $Timer
@onready var count : int = 0 
signal Done


# Called when the node enters the scene tree for the first time.
func _ready():
	timer.wait_time = Typetime
	if Timerstart == true:
		timer.start()
	


func _input(event):
	if InputSTOP == false:
		if InputEnable == true:
			if Input.is_action_pressed("OK"):
				if linecount < (Dialog.size() - 1):
					clearcenter()
					
	if Input.is_action_just_pressed("OK"):
			timer.wait_time = Quickypetime
	if Input.is_action_just_released("OK"):
			timer.wait_time = Typetime


func clearcenter():
	count = 0
	linecount += 1
	charcount = 0
	InputEnable = false
	self.clear()
	self.append_text("[center][center]")

func _on_timer_timeout():
	var textoide : String = Dialog[linecount]
	if charcount < textoide.length():
		InputEnable = false
		self.append_text(textoide[charcount])
		charcount += 1
	if charcount == textoide.length():
		if count < 1:
			print("done")
			count += 1
			InputEnable = true
			Done.emit()
		
