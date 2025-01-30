class_name Puyo
extends Node2D
@onready var sprite : AnimatedSprite2D = $Sprite
@export var status : String = "TETHERED"
var color = randi() % 4 + 1 
var isBomb = false
var is_popping = false
var grid_pos: Vector2i = Vector2i.ZERO
enum {CLEAR, RED, BLUE, GREEN, YELLOW}
#      0      1    2      3       4


var target_fall = 0
signal pop_finished(puyo)

func _ready() -> void:
	isBomb = (randi() % 100) % 17 == 0
	match color:
		1:
			if !isBomb:
				sprite.play("red")
			else:
				sprite.play("red_bomb")
		2:
			if !isBomb:
				sprite.play("blue")
			else:
				sprite.play("blue_bomb")
		3:
			if !isBomb:
				sprite.play("green")
			else:
				sprite.play("green_bomb")
		4:
			if !isBomb:
				sprite.play("yellow")
			else:
				sprite.play("yellow_bomb")

func _on_puyo_free():
	if is_popping:
		return
	else:
		match color:
			1: sprite.play("red_snap")
			2: sprite.play("blue_snap")
			3: sprite.play("green_snap")
			4: sprite.play("yellow_snap")

func pop():
	if is_popping:
		return
	is_popping = true
	match color:
		1: sprite.play("red_free")
		2: sprite.play("blue_free")
		3: sprite.play("green_free")
		4: sprite.play("yellow_free")

func explode():
	if is_popping:
		return
	is_popping = true
	if isBomb:
		match color:
			1: sprite.play("red_bomb_explode")
			2: sprite.play("blue_bomb_explode")
			3: sprite.play("green_bomb_explode")
			4: sprite.play("yellow_bomb_explode")
	match color:
		1: sprite.play("red_explode")
		2: sprite.play("blue_explode")
		3: sprite.play("green_explode")
		4: sprite.play("yellow_explode")

func _on_sprite_animation_finished() -> void:
	if sprite.animation.ends_with("explode"):
		emit_signal("pop_finished", self)
		queue_free()
	if sprite.animation.ends_with("free"):
		_ready()

func _on_sprite_animation_looped() -> void:
	if sprite.animation.ends_with("free"):
		emit_signal("pop_finished", self)
		queue_free()
