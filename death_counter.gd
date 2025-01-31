extends TileMapLayer

var width = 6
var height = 9
var saved = 0
var killed = 0
var next_position = Vector2i(-1,0)
var heart_texture = Vector2i(0,1)
var skull_texture = Vector2i(0,2)
var queue = []
var adding = false
signal game_finished

@onready var counter_tile: TileMapLayer = $counter

func _process(_delta: float) -> void:
	if adding:
		return
	if !queue.is_empty():
		add(queue[-1])
	
func _on_puyo_despawn(cause : String):
	match cause:
		'free':
			saved =+ 1
			queue.append(cause)
		'killed':
			killed += 1
			queue.append(cause)
	if next_position.x == width-1  and next_position.y == height:
		game_finished.emit()
	return true

func add(item):
	adding = true
	match item:
		'free':
			counter_tile.set_cell(get_next_position(next_position), 0, heart_texture)
		'killed':
			counter_tile.set_cell(get_next_position(next_position), 0, skull_texture)
	await get_tree().create_timer(0.2).timeout
	queue.erase(queue.back())
	adding = false
	
func get_next_position(pos : Vector2i) -> Vector2i:
	if next_position.x < width - 1:
		next_position.x += 1
	else:
		next_position.x = 0
		next_position.y += 1
	return Vector2i(next_position.x, next_position.y)
