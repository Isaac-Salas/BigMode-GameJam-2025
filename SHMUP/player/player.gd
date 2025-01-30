extends RigidBody2D
class_name PlayerComponent
@onready var spawner_component = $SpawnerComponent
@onready var uppershot = $Uppershot
@onready var centershot = $Centershot
@onready var lowershot = $Lowershot
@onready var fire_rate_timer = $FireRateTimer
@onready var scale_component = $ScaleComponent
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var move_component = $MoveComponent
@onready var stats_component = $StatsComponent
@onready var move_input_component = $MoveInputComponent
@onready var hurtbox_component = $HurtboxComponent
@onready var shake_component = $ShakeComponent
@onready var cntshot = load("res://projectiles/center_shot.tscn")
@onready var o_2_timer = $O2Timer
@onready var o_2_sum = $O2Sum

@export var ammo = 1000
@export var O2 = 100
# Single, Shotty, or Laser
@onready var currentgun = "Shotty"
@onready var nextgun = ""

var change = "Center"
var bubble = false
var shooting = false
var eating = false
var punching = false
var stopshooting = false
var shootholding = false
var laser 
var somethingeat

# Called when the node enters the scene tree for the first time.
func _ready():
	
	fire_rate_timer.timeout.connect(laserdown)
	o_2_timer.timeout.connect(o2down)
	o_2_sum.timeout.connect(sumao2)
	hurtbox_component.hurt.connect(func(Hitbox : HitboxComponent):
		scale_component.tween_scale()
		shake_component.tween_shake()
		)

func o2down():
	if O2 > 0:
		O2 -= 1
		o_2_timer.start()
	else:
		o_2_timer.start(1)
		stats_component.health -= 1

func _process(_delta):
	
	stopshooting = Input.is_action_just_released("Act1")
	shooting = Input.is_action_just_pressed("Act1")
	eating = Input.is_action_just_pressed("Act2")
	punching = Input.is_action_just_pressed("Act3")
	#print(stopshooting)
	animation()
	evaluate()

	#print(ammo)
func animation():
	animated_sprite_2d.play(change)
	
	#print(shooting)



func _input(_event):
	
	if Input.is_anything_pressed():
		if Input.is_action_pressed("ui_left"):
			animated_sprite_2d.flip_h = true
			change = "Right_Left"
		elif Input.is_action_pressed("ui_right"):
			animated_sprite_2d.flip_h = false
			change = "Right_Left"
		elif Input.is_action_pressed("ui_up"):
			change = "Up_Down"
			animated_sprite_2d.flip_v = false
		elif Input.is_action_pressed("ui_down"):
			change = "Up_Down"
			animated_sprite_2d.flip_v = true
	else:
		#await animated_sprite_2d.animation_finished
		change = "Center"
		
		
		
		
		


	

# Called every frame. 'delta' is the elapsed time since the previous frame.


func evaluate():
	match ammo:
		0:
			currentgun = ""
	
	if ammo == 0 and currentgun == "Laser" and laser != null:
		laser.queue_free()
		
	
	
	match stopshooting:
		true:
			shootholding = false
			if laser != null:
				laser.queue_free()
	
	match shooting:
		true:
			#print("shooting")
			if ammo > 0:
				ammo -= 1
				animated_sprite_2d.flip_h = false
				change = "Shoot"
				scale_component.tween_scale()
				
				match currentgun:
					"Single":
						spawner_component.spawn(centershot.global_position)
					"Shotty":
						spawner_component.scene = load("res://projectiles/trishot.tscn")
						var upper = spawner_component.spawn(uppershot.global_position)
						upper.get_node("MoveComponent").velocity.y = -50
						spawner_component.spawn(centershot.global_position)
						var lower = spawner_component.spawn(lowershot.global_position)
						lower.get_node("MoveComponent").velocity.y = 50
					"Laser":
						shootholding = true
						spawner_component.scene = load("res://projectiles/Laser.tscn")
						laser = spawner_component.spawn(centershot.global_position)
						#laser.get_node("MoveComponent").velocity = Vector2(0,0)
					"":
						pass

			else:
				scale_component.tween_scale()

	match eating:
		true:
			if somethingeat != null:
				somethingeat.get_node("StatsComponent").health = 0
				somethingeat = null
				match nextgun:
					"Single":
						if currentgun == nextgun:
							ammo += 3
						else:
							ammo = 3 
					"Shotty":
						if currentgun == nextgun:
							ammo += 1
						else:
							ammo = 1 
					"Laser":
						if currentgun == nextgun:
							ammo += 100
						else:
							ammo = 100
				currentgun = nextgun
				
			animated_sprite_2d.flip_h = false
			change = "Eat"
			scale_component.tween_scale()
		false:
			pass
			
	match punching:
		true:
			animated_sprite_2d.flip_h = false
			change = "Punch"
			scale_component.tween_scale()

func laserdown():
	if currentgun == "Laser" and shootholding == true and ammo > 0:
		ammo -=1
	else:
		pass


#
#func shoot():
	#spawner_component.spawn(centershot.global_position)
	#scale_component.tween_scale()



func _on_eat_area_entered(area):
	if area.get_parent().get_parent().find_child("Single"):
		somethingeat = area.get_parent().get_parent()
		nextgun = "Single"
	elif area.get_parent().get_parent().find_child("Shotty"):
		somethingeat = area.get_parent().get_parent()
		nextgun = "Shotty"
	elif  area.get_parent().get_parent().find_child("Laser"):
		nextgun = "Shotty"


func _on_air_area_entered(area):
	o_2_timer.stop()
	o_2_sum.start(0.1)

func sumao2 ():
	if O2 < 100:
		O2 += 1

func _on_air_area_exited(area):
	o_2_sum.stop()
	o_2_timer.start()
