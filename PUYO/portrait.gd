extends Node2D
@onready var enemigote: AnimatedSprite2D = $Enemigote

func pog():
	enemigote.play("pogger")

func happy():
	enemigote.play("happy")

func mad():
	enemigote.play("mad")

func _on_enemigote_animation_finished() -> void:
	enemigote.play("default")

func _on_spawner_play(sfx: Variant) -> void:
	match sfx:
		"pop": happy()
		"explode": mad()
		"pogger": pog()
