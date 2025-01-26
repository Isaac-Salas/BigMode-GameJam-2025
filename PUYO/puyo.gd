class_name Puyo
extends Node2D
@onready var sprite : AnimatedSprite2D = $Sprite
@export var status : String = "TETHERED"
var color = randi() % 4 + 1 
var grid_pos: Vector2i = Vector2i.ZERO
enum {CLEAR, RED, BLUE, GREEN, YELLOW}
#      0      1      2      3    4
var target_fall = 0

func _ready() -> void:
	match color:
		1: sprite.play("red")
		2: sprite.play("blue")
		3: sprite.play("green")
		4: sprite.play("yellow")


func _on_puyo_free():
	status = "FREE"
	match color:
		1: sprite.play("red_snap")
		2: sprite.play("blue_snap")
		3: sprite.play("green_snap")
		4: sprite.play("yellow_snap")
	free_fall()

func pop():
	match color:
		1: sprite.play("red_explode")
		2: sprite.play("blue_explode")
		3: sprite.play("green_explode")
		4: sprite.play("yellow_explode")

func free_fall():
	status = "STATIC"

func _on_sprite_animation_finished() -> void:
	if sprite.animation == "red_explode" or sprite.animation == "blue_explode" or  sprite.animation == "green_explode" or  sprite.animation == "green_explode":
		print("exploded")
		queue_free()
