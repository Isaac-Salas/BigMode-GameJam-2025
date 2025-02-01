extends TextureButton
@onready var integer : bool = true
@onready var crt : bool = false
@onready var noise : bool = true

@export var shaders : Shadertoggle
@onready var cosa = $Cosa



# Called when the node enters the scene tree for the first time.
func _ready():
	print(get_tree().root.content_scale_mode)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_check_box_toggled(toggled_on):
	match toggled_on:
		true:
			pass
		false:
			pass
			#get_tree().root.content_scale_mode = enum
		


func _on_pressed():
	cosa.visible = true
