class_name AntiplayerMoveComponent
extends Node
@export var actor : Node2D
@export var velocity : Vector2
@export var active = true
@export var rotation = 0
@onready var Player : PlayerComponent
var playerpos
func _ready():
	Player = self.get_parent().get_parent().find_child("Player")
	if Player != null:
		playerpos = Player.global_position
	else:
		playerpos = Vector2(0,0)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
#This makes the projectile follow you
	#playerpos = Player.global_position
	if Player != null:
		playerpos.y = Player.global_position.y
	else:
		playerpos = Vector2(-135,0)
	
	match active:
		true:
			actor.rotation_degrees += rotation
			var test = (playerpos.y - actor.global_position.y)*(delta*velocity.y)
			actor.translate(Vector2(velocity.x*delta,test))
		false:
			pass
	
