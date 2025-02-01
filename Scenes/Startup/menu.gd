extends Control

@onready var crtcheck = $Cosa/CRT/Crtcheck
@onready var noisecheck = $Cosa/Noise2/Noisecheck
@onready var back = $Cosa/Back


@export var shaders : Shadertoggle
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass




func _on_noisecheck_toggled(toggled_on):
	match toggled_on:
		true:
			crtcheck.button_pressed = false
			shaders.noise.visible = true
			shaders.crt.visible = false
			Global.shader = "noise"
			
		false:
			crtcheck.button_pressed = true
			shaders.noise.visible = false
			shaders.crt.visible = true
			Global.shader = "crt"


func _on_crtcheck_toggled(toggled_on):
	match toggled_on:
		true:
			noisecheck.button_pressed = false
			shaders.noise.visible = false
			shaders.crt.visible = true
			Global.shader = "crt"
			
		false:
			noisecheck.button_pressed = true
			shaders.noise.visible = true
			shaders.crt.visible = false
			Global.shader = "noise"


func _on_back_pressed():
	self.visible = false
