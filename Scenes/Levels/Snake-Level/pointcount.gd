extends Node2D
@onready var rich_text_label : RichTextLabel = $RichTextLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	#print(Global.alltheshit)
	rich_text_label.append_text(str("Frutas:", Global.allthefruit))
	rich_text_label.newline()
	rich_text_label.append_text(str("Aliens", Global.allthealiens))
	#if Global.alltheshit != null:
		#for i in Global.alltheshit:
			#add_sibling(i)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
