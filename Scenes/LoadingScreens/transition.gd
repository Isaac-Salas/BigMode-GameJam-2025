extends Node2D
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func opening():
	show()
	sprite.play("fade_in")
	await sprite.animation_finished
	hide()
	return true

func closing():
	show()
	sprite.play("fade_out")
	await sprite.animation_finished
	hide()
	return true
