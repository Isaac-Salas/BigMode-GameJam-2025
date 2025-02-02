extends Control
var puyo_scene = preload("res://PUYO/board.tscn")
var snake_scene = preload("res://Scenes/Levels/Snake-Level/cargador_de_papus.tscn")
const PUYO_LOAD = preload("res://Scenes/LoadingScreens/PuyoLoad.tscn")
const SNAKE_LOAD = preload("res://Scenes/LoadingScreens/SnakeLoad.tscn")

func _on_sub_menu_game_start(game: String) -> void:
	print(game)
	match game:
		"Prism":
			get_tree().change_scene_to_packed(PUYO_LOAD)
		"Leaf":
			return
			#get_tree().change_scene_to_packed(PUYO_LOAD)
		"Swamp":
			return
			#get_tree().change_scene_to_packed(PUYO_LOAD)
		"Egg":
			get_tree().change_scene_to_packed(SNAKE_LOAD)
