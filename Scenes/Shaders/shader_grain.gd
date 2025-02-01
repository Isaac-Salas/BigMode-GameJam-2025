extends Node2D
class_name Shadertoggle
@onready var crt :ColorRect = $CRT
@onready var noise : ColorRect = $Noise
@onready var referenbcia = $Referenbcia

func _ready():
	match Global.shader:
		"crt":
			crt.visible = true
			noise.visible = false
		"noise":
			noise.visible = true
			crt.visible = false
