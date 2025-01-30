extends Node2D
class_name EnemyWave
var Ecount = 0
signal waveend()
@onready var emitonce = true
var new
# Called when the node enters the scene tree for the first time.
func _ready():
	for i in self.get_children ():
		Ecount += 1
	print(Ecount)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	#print(get_children())
	if get_children() == []:
		match emitonce:
			true:
				waveend.emit()
				emitonce = false
			false:pass
		#print("Yes")
		
	
	


func _on_visible_on_screen_notifier_2d_screen_entered():
	print("IMin")
	for i in self.get_children():
		i.Shooting = true
		i.find_child("EnemyTest").find_child("MoveComponent").active = false
