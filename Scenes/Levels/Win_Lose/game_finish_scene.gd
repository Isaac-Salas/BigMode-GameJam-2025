extends Node2D
@onready var planet: AnimatedSprite2D = $planet
@onready var enemy_reaction: AnimatedSprite2D = $enemy_reaction
const LEVEL_SELECT_LOAD = preload("res://Scenes/LoadingScreens/LevelSelectLoad.tscn")
@onready var explosion: AnimatedSprite2D = $explosion
@onready var explosion_2: AnimatedSprite2D = $explosion2

func _ready() -> void:
	set_ending(Global.game, Global.ending)

func set_ending(game: String, ending: String):
	planet.animation = game + "_planet"
	planet.play()
	enemy_reaction.animation = game + "_" + ending
	enemy_reaction.play()
	if ending == "bad":
		await get_tree().create_timer(4).timeout
		planet.hide()
		explosion.play()
		explosion.show()
		explosion_2.play()
		explosion_2.show()
		
	

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if Global.ending == "bad":
		await explosion.animation_finished
		
	get_tree().change_scene_to_packed(LEVEL_SELECT_LOAD)
