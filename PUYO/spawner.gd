extends Node2D

@onready var fall: Timer = $fall
@onready var puyo_blueprint: PackedScene = preload("res://puyo.tscn")

signal free_puyo()
signal pop_puyo()

var puyo_rotate
var puyo_main
var puyorotation = 0
var cells = [
	[0, 0, 0, 0, 0, 0],
	[0, 0, 0, 0, 0, 0],
	[0, 0, 0, 0, 0, 0],
	[0, 0, 0, 0, 0, 0],
	[0, 0, 0, 0, 0, 0],
	[0, 0, 0, 0, 0, 0],
	[0, 0, 0, 0, 0, 0],
	[0, 0, 0, 0, 0, 0],
	[0, 0, 0, 0, 0, 0],
	[0, 0, 0, 0, 0, 0],
	[0, 0, 0, 0, 0, 0],
	[0, 0, 0, 0, 0, 0],
]

func spawn_puyos():
	puyorotation = 0
	puyo_rotate = puyo_blueprint.instantiate()
	puyo_rotate.set("status", "Rotate")
	puyo_rotate.position.x += 36
	puyo_rotate.grid_pos.x = 3
	
	puyo_main = puyo_blueprint.instantiate()
	puyo_main.grid_pos.x = 2
	puyo_main.set("status", "Main")
	
	add_child(puyo_rotate)
	add_child(puyo_main)
	
	connect("free_puyo", puyo_main._on_puyo_free)
	connect("free_puyo", puyo_rotate._on_puyo_free)

func _ready():
	spawn_puyos()

func left(puyo):
	match puyo.status:
		"Rotate":
			if puyorotation == 0 and is_clear(puyo.grid_pos + Vector2i(-2,0)):
				puyo.position.x -= 36
				puyo.grid_pos.x -= 1
				return true
			elif is_clear(puyo.grid_pos + Vector2i(-1,0)) and puyorotation != 0:
				puyo.position.x -= 36
				puyo.grid_pos.x -= 1
				return true
			else:
				return false
		"Main":
			if puyorotation == 2 and is_clear(puyo.grid_pos + Vector2i(-2,0)):
				puyo.position.x -= 36
				puyo.grid_pos.x -= 1
				return true
			elif is_clear(puyo.grid_pos + Vector2i(-1,0)) and puyorotation != 2:
				puyo.position.x -= 36
				puyo.grid_pos.x -= 1
				return true
			else:
				return false

func right(puyo: Puyo):
	match puyo.status:
		"Rotate":
			if puyorotation == 2 and is_clear(puyo.grid_pos + Vector2i(2,0)):
				puyo.position.x += 36
				puyo.grid_pos.x += 1
				return true
			elif is_clear(puyo.grid_pos + Vector2i(1,0)) and puyorotation != 2:
				puyo.position.x += 36
				puyo.grid_pos.x += 1
				return true
			else:
				return false
		"Main":
			if puyorotation == 0 and is_clear(puyo.grid_pos + Vector2i(2,0)):
				puyo.position.x += 36
				puyo.grid_pos.x += 1
				return true
			elif is_clear(puyo.grid_pos + Vector2i(1,0)) and puyorotation != 0:
				puyo.position.x += 36
				puyo.grid_pos.x += 1
				return true
			else:
				return false

func is_clear(pos):
	if in_bounds(pos):
		return cells[pos.y][pos.x] == 0

func update_cells(puyo : Puyo):
	cells[puyo.grid_pos.y][puyo.grid_pos.x] = puyo.color
	var connected = check_connected(puyo.grid_pos, puyo.color)
	if connected.size() > 3:
		for pos in connected:
			cells[pos.y][pos.x] = 0
			var puyo_to_remove = get_puyo_at_position(pos)
			if puyo_to_remove:
				puyo_to_remove.pop()


func get_puyo_at_position(pos: Vector2i) -> Puyo:
	for child in get_children():
		if child is Puyo and child.grid_pos == pos:
			return child
	return null

func in_bounds(pos: Vector2i):
	if pos.x < 0 or pos.x > 5 or pos.y < 0 or pos.y > 11:
		return false
	else:
		return true

func is_same_color(color: int, pos: Vector2i):
	if in_bounds(pos) and color == get_puyo_at_position(pos).color:
		return true
	else:
		return false

func check_connected(pos: Vector2i, color: int, connected: Array = []) -> Array:
	connected.append(pos)
	var directions = [
		Vector2i(1, 0),
		Vector2i(0, 1),
		Vector2i(-1, 0),
		Vector2i(0, -1)
	]

	for direction in directions:
		var next_pos = pos + direction
		if !is_clear(next_pos) and is_same_color(color, next_pos) and next_pos not in connected:
			check_connected(next_pos, color, connected)
	return connected


func drop_puyos():
	for x in range(6):
		var drop_to = 11
		for y in range(11, -1, -1):
			if cells[y][x] != 0:
				if drop_to != y:
					cells[drop_to][x] = cells[y][x]
					cells[y][x] = 0
				drop_to -= 1


func find_fall():
	match puyorotation:
		0, 2, 3:
			while is_clear(puyo_main.grid_pos + Vector2i(0, 1)):
				puyo_main.position += Vector2(0, 36)
				puyo_main.grid_pos += Vector2i(0, 1)
			update_cells(puyo_main)
			while is_clear(puyo_rotate.grid_pos + Vector2i(0, 1)):
				puyo_rotate.position += Vector2(0, 36)
				puyo_rotate.grid_pos += Vector2i(0, 1)
			update_cells(puyo_rotate)
		1:
			while is_clear(puyo_rotate.grid_pos + Vector2i(0, 1)):
				puyo_rotate.position += Vector2(0, 36)
				puyo_rotate.grid_pos += Vector2i(0, 1)
			update_cells(puyo_rotate)
			while is_clear(puyo_main.grid_pos + Vector2i(0, 1)):
				puyo_main.position += Vector2(0, 36)
				puyo_main.grid_pos += Vector2i(0, 1)
			update_cells(puyo_main)
	
func _input(event):
	if Input.is_action_pressed("ui_down"):
		if fall.time_left > 0.2:
			fall.start(0.2)
	
	if Input.is_action_just_pressed("ui_right"):
		right(puyo_main)
		right(puyo_rotate)
	
	if Input.is_action_just_pressed("ui_left"):
		left(puyo_main)
		left(puyo_rotate)
	
	if Input.is_action_just_pressed("clockwise"):
		match puyorotation:
			0:
				if is_clear(puyo_main.grid_pos + Vector2i(0, 1)):
					puyo_rotate.position = puyo_main.position + Vector2(0, 36)
					puyo_rotate.grid_pos = puyo_main.grid_pos + Vector2i(0, 1)
					puyorotation = 1
			1:
				if is_clear(puyo_main.grid_pos + Vector2i(-1, 0)):
					puyo_rotate.position = puyo_main.position + Vector2(-36, 0)
					puyo_rotate.grid_pos = puyo_main.grid_pos + Vector2i(-1, 0)
					puyorotation = 2
				elif right(puyo_main):
					puyo_rotate.position = puyo_main.position + Vector2(-36, 0)
					puyo_rotate.grid_pos = puyo_main.grid_pos + Vector2i(-1, 0)
					puyorotation = 2
			2:
				if is_clear(puyo_main.grid_pos + Vector2i(0, -1)):
					puyo_rotate.position = puyo_main.position + Vector2(0, -36)
					puyo_rotate.grid_pos = puyo_main.grid_pos + Vector2i(0, -1)
					puyorotation = 3
			3:
				if is_clear(puyo_main.grid_pos + Vector2i(1, 0)):
					puyo_rotate.position = puyo_main.position + Vector2(36, 0)
					puyo_rotate.grid_pos = puyo_main.grid_pos + Vector2i(1, 0)
					puyorotation = 0
				elif left(puyo_main):
					puyo_rotate.position = puyo_main.position + Vector2(36, 0)
					puyo_rotate.grid_pos = puyo_main.grid_pos + Vector2i(1, 0)
					puyorotation = 0
	
	if Input.is_action_just_pressed("counterclockwise"):
		match puyorotation:
			0:
				if is_clear(puyo_main.grid_pos + Vector2i(0, -1)):
					puyo_rotate.position = puyo_main.position + Vector2(0, -36)
					puyo_rotate.grid_pos = puyo_main.grid_pos + Vector2i(0, -1)
					puyorotation = 3
			1:
				if is_clear(puyo_main.grid_pos + Vector2i(1, 0)):
					puyo_rotate.position = puyo_main.position + Vector2(36, 0)
					puyo_rotate.grid_pos = puyo_main.grid_pos + Vector2i(1, 0)
					puyorotation = 0
				elif left(puyo_main):
					puyo_rotate.position = puyo_main.position + Vector2(36, 0)
					puyo_rotate.grid_pos = puyo_main.grid_pos + Vector2i(1, 0)
					puyorotation = 0
			2:
				if is_clear(puyo_main.grid_pos + Vector2i(0, 1)):
					puyo_rotate.position = puyo_main.position + Vector2(0, 36)
					puyo_rotate.grid_pos = puyo_main.grid_pos + Vector2i(0, 1)
					puyorotation = 1
			3:
				if is_clear(puyo_main.grid_pos + Vector2i(-1, 0)):
					puyo_rotate.position = puyo_main.position + Vector2(-36, 0)
					puyo_rotate.grid_pos = puyo_main.grid_pos + Vector2i(-1, 0)
					puyorotation = 2
				elif right(puyo_main):
					puyo_rotate.position = puyo_main.position + Vector2(-36, 0)
					puyo_rotate.grid_pos = puyo_main.grid_pos + Vector2i(-1, 0)
					puyorotation = 2

func _on_fall_timeout():
	fall.start(0.5)
	if is_clear(puyo_main.grid_pos + Vector2i(0, 1)) and is_clear(puyo_rotate.grid_pos + Vector2i(0, 1)):
		puyo_main.position.y += 36
		puyo_rotate.position.y += 36
		puyo_main.grid_pos.y += 1
		puyo_rotate.grid_pos.y += 1
	else:
		find_fall()
		free_puyo.emit()
		disconnect("free_puyo", puyo_main._on_puyo_free)
		disconnect("free_puyo", puyo_rotate._on_puyo_free)
		for i in range(12):
			print(cells[i][0], cells[i][1], cells[i][2], cells[i][3], cells[i][4], cells[i][5])
		spawn_puyos()
