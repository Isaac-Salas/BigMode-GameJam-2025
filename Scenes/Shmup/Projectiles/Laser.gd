extends Node2D

@onready var speed = 20
@onready var orb_1 = $Orb1
@onready var orb_2 = $Orb2
@onready var orb_3 = $Orb3
@onready var orb_4 = $Orb4
@onready var orb_5 = $Orb5
@onready var orb_6 = $Orb6
@onready var orb_7 = $Orb7
@onready var orb_8 = $Orb8
@onready var orb_9 = $Orb9
@onready var orb_10 = $Orb10
@onready var scale_component = $ScaleComponent
@export var offset = 8
var playerpos
var scalefact = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	orb_1.play("Inicio")
	orb_2.play("Mitad")
	orb_3.play("Mitad")
	orb_4.play("Mitad")
	orb_5.play("Mitad")
	orb_6.play("Mitad")
	orb_7.play("Mitad")
	orb_8.play("Mitad")
	orb_9.play("Mitad")
	orb_10.play("Final")
	for i in self.get_children():
		if i == AnimatedSprite2D:
			i.transform.scale = i.transform.scale*scalefact
			scalefact += 1
			print(scalefact)
		else:
			pass




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	playerpos = get_parent().find_child("Player")
	playerpos = playerpos.global_position
	orb_1.global_position += (Vector2(playerpos.x+offset+5 ,playerpos.y) - orb_1.global_position)*(delta*speed)
	orb_2.global_position += (Vector2(orb_1.global_position.x+offset ,orb_1.global_position.y) - orb_2.global_position)*(delta*speed)
	orb_3.global_position += (Vector2(orb_2.global_position.x+offset ,orb_2.global_position.y) - orb_3.global_position)*(delta*speed)
	orb_4.global_position += (Vector2(orb_3.global_position.x+offset ,orb_3.global_position.y) - orb_4.global_position)*(delta*speed)
	orb_5.global_position += (Vector2(orb_4.global_position.x+offset ,orb_4.global_position.y) - orb_5.global_position)*(delta*speed)
	orb_6.global_position += (Vector2(orb_5.global_position.x+offset ,orb_5.global_position.y) - orb_6.global_position)*(delta*speed)
	orb_7.global_position += (Vector2(orb_6.global_position.x+offset ,orb_6.global_position.y) - orb_7.global_position)*(delta*speed)
	orb_8.global_position += (Vector2(orb_7.global_position.x+offset ,orb_7.global_position.y) - orb_8.global_position)*(delta*speed)
	orb_9.global_position += (Vector2(orb_8.global_position.x+offset ,orb_8.global_position.y) - orb_9.global_position)*(delta*speed)
	orb_10.global_position += (Vector2(orb_9.global_position.x+offset ,orb_9.global_position.y) - orb_10.global_position)*(delta*speed)
