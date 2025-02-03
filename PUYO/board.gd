extends Node2D

@onready var mult: Label = $mult/Mult
@onready var total: Label = $total/Total
@onready var base: Label = $base/Base
@onready var transition: Node2D = $transition
@onready var spawner: Node2D = $Spawner
@onready var counter: TileMapLayer = $counter

const GAME_FINISH_LOADER = preload("res://Scenes/LoadingScreens/game_finish_loader.tscn")

@onready var pop: AudioStreamPlayer = $pop
const PUYO_POP = preload("res://Assets/SFX/Puyo/puyo_pop.wav")

@onready var explode: AudioStreamPlayer = $explode
const PUYO_BOOM = preload("res://Assets/SFX/Puyo/puyo_boom.wav")

@onready var jingle: AudioStreamPlayer = $jingle
@onready var move: AudioStreamPlayer = $move
const PUYO_SIDE_SLIDE = preload("res://Assets/SFX/Puyo/puyo_side slide.wav")
@onready var rotate: AudioStreamPlayer = $rotate
const PUYO_ROTATE = preload("res://Assets/SFX/Puyo/puyo_rotate.wav")
@onready var snap: AudioStreamPlayer = $snap
const PUYO_PLACE = preload("res://Assets/SFX/Puyo/puyo_place.wav")
@onready var score_pogger: AudioStreamPlayer = $score_pogger
@onready var pogger_bad: AudioStreamPlayer = $pogger_bad



var cum_mult = 0
var cum_base = 0
var grand_total = 0

func sfx(sound):
	match sound:
		"pop": 
			pop.play()
		"snap":
			snap.play()
		"sides":
			move.play()
		"explode":
			explode.play()
		"rotate":
			rotate.play()
		"pogger":
			if counter.killed > 10:
				if not pogger_bad.playing:
					pogger_bad.play()
			else: 
				if not score_pogger.playing:
					score_pogger.play()


func _ready() -> void:
	await transition.opening()
	spawner.fall.start()
	mult.text = "x 1"
	base.text = "0"
	total.text = "0"

func _on_spawner_puyo_multiplied(puyo_multiplied: Variant) -> void:
	cum_mult = puyo_multiplied
	mult.text = "x " + str(cum_mult)

func _on_spawner_score_base(value: Variant) -> void:
	cum_base += value
	base.text = str(cum_base)

func _on_spawner_score_updated(score: Variant) -> void:
	cum_base = 0
	cum_mult = 0
	grand_total += score
	mult.text = "x 1"
	total.text = str(grand_total)

func _on_counter_game_finished(ending) -> void:
	Global.game = "puyo"
	Global.ending = ending
	while spawner.shit_happening:
		await get_tree().process_frame
	await (transition.closing())
	get_tree().change_scene_to_packed(GAME_FINISH_LOADER)
