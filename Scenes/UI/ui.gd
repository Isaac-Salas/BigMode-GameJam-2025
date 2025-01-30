extends Control
@export var Player : PlayerComponent
@onready var health = $Health
@onready var o_2 = $O2
@onready var ammo = $Ammo
@onready var gun = $Gun



@onready var stats

# Called when the node enters the scene tree for the first time.
func _ready():
	stats = Player.find_child("StatsComponent")
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if stats != null:
		health.text = str(" HP: ", stats.health)
		o_2.text = str(" O2: ", Player.O2)
		ammo.text = str("AM : ", Player.ammo)
		gun.text = str("GUN: ", Player.currentgun)
	else:
		health.text = str("HP: ", 0)
	
