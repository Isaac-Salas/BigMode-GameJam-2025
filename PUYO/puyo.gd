class_name Puyo
extends Node2D
@onready var sprite : AnimatedSprite2D = $Sprite
@export var status : String = "TETHERED"
var color = randi() % 4 + 1 
var is_popping = false
var grid_pos: Vector2i = Vector2i.ZERO
enum {CLEAR, RED, BLUE, GREEN, YELLOW}
#      0      1    2      3       4
var target_fall = 0
signal pop_finished(puyo)

func _ready() -> void:
	match color:
		1: sprite.play("red")
		2: sprite.play("blue")
		3: sprite.play("green")
		4: sprite.play("yellow")

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

func _on_sprite_animation_finished() -> void:
	if sprite.animation.ends_with("explode"):
		emit_signal("pop_finished", self)  # Notify popping is complete
		queue_free()
	if sprite.animation.ends_with("free"):
		_ready()

func _on_sprite_animation_looped() -> void:
	if sprite.animation.ends_with("free"):
		emit_signal("pop_finished", self)  # Notify popping is complete
		queue_free()
