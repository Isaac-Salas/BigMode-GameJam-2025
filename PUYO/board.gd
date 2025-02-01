extends Node2D

@onready var mult: Label = $mult/Mult
@onready var total: Label = $total/Total
@onready var base: Label = $base/Base

var cum_mult = 0
var cum_base = 0
var grand_total = 0

func _ready() -> void:
	mult.text = "x 1"
	base.text = "0"
	total.text = "0"


func _on_spawner_puyo_multiplied(puyo_multiplied: Variant) -> void:
	cum_mult += puyo_multiplied
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
	


func _on_counter_game_finished() -> void:
	print("game finish")
