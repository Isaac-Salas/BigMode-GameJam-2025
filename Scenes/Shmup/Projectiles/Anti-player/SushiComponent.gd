class_name EdibleComponent
extends Node2D
@onready var center_shot = $CenterShot

@onready var sprite_2d = $CenterShot/Sprite2D
@export var collidable = true
@onready var scale_component = $ScaleComponent
@onready var collision_shape_2d = $CenterShot/CollisionShape2D
@onready var antiplayer_move_component = $AntiplayerMoveComponent
@onready var hitbox_component = $CenterShot/HitboxComponent
@onready var Player : PlayerComponent



# Called when the node enters the scene tree for the first time.
func _ready():
	scale_component.tween_scale()
	
	

#func _on_area_2d_body_entered(body):
	#print(body.name)
	#if body.find_child(\"Hitable\"):
#
		#area_2d.queue_free()
		#collision_shape_2d.disabled = false
		#center_shot.set_deferred(\"freeze\", false)
		#move_component.active = false
		##timer.start()
		##timer.timeout.connect(destroy)
		#sprite_2d.modulate = Color(0.5,0.5,0.5,1)

func destroy():
	queue_free()





func _on_visible_on_screen_notifier_2d_screen_exited():
	print("destroying")
	destroy()


func _on_hitbox_component_area_entered(area):
	if collidable == true:
		pass
	else:
		center_shot.collision_layer = 0
		center_shot.collision_mask = 0
	
	if area.name == "HurtboxComponent":
		hitbox_component.queue_free()
		collision_shape_2d.set_deferred("disabled", false)
		center_shot.set_deferred("freeze", false)
		antiplayer_move_component.active = false
		scale_component.tween_scale()
		#timer.start()
		#timer.timeout.connect(destroy)
		sprite_2d.modulate = Color(0.5,0.5,0.5,0.5)
	elif area.name== "Eat":
		sprite_2d.play("detected")
		
