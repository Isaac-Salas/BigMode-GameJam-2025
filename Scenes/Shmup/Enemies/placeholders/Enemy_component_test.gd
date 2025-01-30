class_name EnemyComponent
extends RigidBody2D


@onready var stats_component = %StatsComponent
@onready var move_component = $MoveComponent
 


#func _on_area_2d_area_entered(area):
	#print(area.name)
	#if area.name == "ShotHit":
		#collision_layer = 512
		#collision_mask = 512
		#linear_velocity.x = randi_range(300,600)
		#linear_velocity.y = randi_range(-400,400)
		#angular_velocity = 100
		#move_component.active = false
		#set_deferred("freeze", false)
