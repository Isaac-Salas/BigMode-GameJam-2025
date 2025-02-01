extends Node2D
@export var controller = 'player'
@onready var fall: Timer = $fall
@onready var puyo_blueprint: PackedScene = preload("res://PUYO/puyo.tscn")
@onready var popping_puyos = []

@onready var base_scale: ScaleComponent = $"../baseScale"
@onready var mult_scale: ScaleComponent = $"../multScale"
@onready var update_score: ScaleComponent = $"../updateScore"

var total_score = 0
var current_mult = 1
@warning_ignore("unused_signal")
signal score_updated(score)
@warning_ignore("unused_signal")
signal score_base(base)
@warning_ignore("unused_signal")
signal puyo_multiplied(puyo_multiplied)
signal free_puyo()
var explode_puyo = -1

var shit_happening = false
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
signal puyo_removed(cause : String)

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
	if !puyo_main.isBomb:
		connect("free_puyo", puyo_main._on_puyo_free)
	if !puyo_rotate.isBomb:
		connect("free_puyo", puyo_rotate._on_puyo_free)

func display_board():
	print("row: ", 0, 1, 2 ,3 ,4, 5)
	for row in range (12):
		print(row, " : ",cells[row][0],cells[row][1],cells[row][2],cells[row][3],cells[row][4],cells[row][5])

func _ready():
	spawn_puyos()

func left(puyo: Puyo):
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
	return in_bounds(pos) and cells[pos.y][pos.x] == 0

func add_puyo(puyo: Puyo):
	cells[puyo.grid_pos.y][puyo.grid_pos.x] = puyo.color
	if puyo.grid_pos.y == 0 and puyo.grid_pos.x == 2:
		get_tree().reload_current_scene()

func grid_to_world(grid_pos: Vector2i):
	return Vector2((grid_pos.x-2) * 36, grid_pos.y * 36)
	
func check_connected(pos: Vector2i, color: int, connected: Array = [], visited: Dictionary = {}):
	fall.stop()
	if visited.has(pos):
		return connected
	visited[pos] = true
	connected.append(pos)
	
	var directions = [
		Vector2i(1, 0),
		Vector2i(0, 1),
		Vector2i(-1, 0),
		Vector2i(0, -1)
	]

	for direction in directions:
		var next_pos = pos + direction
		if in_bounds(next_pos) and !is_clear(next_pos) and is_same_color(color, next_pos) and next_pos not in visited:
			check_connected(next_pos, color, connected, visited)
	return connected

func get_puyo_at_position(pos: Vector2i):
	for child in get_children():
		if child is Puyo and child.grid_pos == pos:
			return child
	return null

func animate_fall(puyo, drop_to):
	while puyo.position.y != drop_to.y:
		puyo.position += Vector2(0, 36)
		await get_tree().create_timer(0.05).timeout
	return true

func in_bounds(pos: Vector2i):
	return pos.x >= 0 and pos.x <= 5 and pos.y >= 0 and pos.y <= 11

func is_same_color(color: int, pos: Vector2i):
	if in_bounds(pos) and !is_clear(pos):
		var puyo_at_pos = get_puyo_at_position(pos)
		return puyo_at_pos and color == puyo_at_pos.color
	return false

func _on_puyo_popped(puyo):
	if puyo in popping_puyos:
		popping_puyos.erase(puyo)

func clear_all(color):
	fall.stop()
	shit_happening = true
	var noncolorpuyos = []
	print("clearing", color)
	for row in range (12):
		for col in range(6):
			var puyo_maybe_pop = cells[row][col]
			if puyo_maybe_pop != 0 and puyo_maybe_pop != color:
				noncolorpuyos.append(Vector2i(col,row))
			elif (puyo_maybe_pop != 0 and puyo_maybe_pop == color):
				cells[row][col] = 0
				var puyo = get_puyo_at_position(Vector2i(col,row))
				puyo.explode()
				puyo_removed.emit("killed")
				
	explode_puyo = -1
	await get_tree().create_timer(0.6).timeout
	await drop_puyos()
	var actual_puyo = []
	for positions in noncolorpuyos:
		actual_puyo.append(get_puyo_at_position(positions))
	return actual_puyo


func update_cells(target_puyos: Array, score) -> bool:
	fall.stop()
	shit_happening = true
	var all_popped_positions = {}
	var chain_occurred = false
	
	if explode_puyo != -1:
		await update_cells(await clear_all(explode_puyo), score)
		chain_occurred = true
	for puyo in target_puyos:
		if puyo == null:
			continue
		var connected = check_connected(puyo.grid_pos, puyo.color)
		if connected.size() > 3:
			chain_occurred = true
			for pos in connected:
				all_popped_positions[pos] = true
				
	if chain_occurred:
		current_mult += 1
		mult_scale.scale_amount = Vector2(current_mult, current_mult)
		mult_scale.tween_scale()
		emit_signal("puyo_multiplied", current_mult)
		popping_puyos.clear()
		for pos in all_popped_positions.keys():
			cells[pos.y][pos.x] = 0
			var puyo_to_pop = get_puyo_at_position(pos)
			if puyo_to_pop:
				if puyo_to_pop.isBomb:
					puyo_to_pop.explode()
					explode_puyo = puyo_to_pop.color
					popping_puyos.append(puyo_to_pop)
					await get_tree().create_timer(1).timeout
					puyo_removed.emit("killed")
					await update_cells([], score)
					break
				elif not puyo_to_pop.is_connected("pop_finished", _on_puyo_popped):
					puyo_to_pop.connect("pop_finished", _on_puyo_popped)
				popping_puyos.append(puyo_to_pop)
				puyo_to_pop.pop()
				puyo_removed.emit("free")
				score += 200
				base_scale.scale_amount = Vector2(score/100, score/100)
				base_scale.tween_scale()
				emit_signal("score_base", 200)
		
		while popping_puyos.size() > 0:
			await get_tree().process_frame
		await get_tree().create_timer(0.2).timeout
		
		var dropped_puyos = await drop_puyos()
		await update_cells(dropped_puyos, score)
		return true
	return false

func drop_puyos() -> Array:
	fall.stop()
	shit_happening = true
	var dropped = []
	for x in range(6):
		var drop_to = 11
		for y in range(11, -1, -1):
			if cells[y][x] != 0:
				if drop_to != y:
					cells[drop_to][x] = cells[y][x]
					cells[y][x] = 0
					var puyo = get_puyo_at_position(Vector2i(x, y))
					if puyo:
						dropped.append(puyo)
						puyo.grid_pos = Vector2i(x, drop_to)
						animate_fall(puyo, grid_to_world(Vector2i(x, drop_to)))
						free_puyo.emit()
				drop_to -= 1
	await get_tree().create_timer(0.3).timeout
	return dropped
	

func find_fall():
	var score = 0
	match puyorotation:
		0, 2, 3:
			while is_clear(puyo_main.grid_pos + Vector2i(0, 1)):
				puyo_main.position += Vector2(0, 36)
				puyo_main.grid_pos += Vector2i(0, 1)
				await get_tree().create_timer(0.05).timeout
			add_puyo(puyo_main)
			score += 100
			base_scale.scale_amount = Vector2(score/100, score/100)
			base_scale.tween_scale()
			emit_signal("score_base", 100)
			while is_clear(puyo_rotate.grid_pos + Vector2i(0, 1)):
				puyo_rotate.position += Vector2(0, 36)
				puyo_rotate.grid_pos += Vector2i(0, 1)
				await get_tree().create_timer(0.05).timeout
			add_puyo(puyo_rotate)
			score += 100
			base_scale.scale_amount = Vector2(score/100, score/100)
			base_scale.tween_scale()
			emit_signal("score_base", 100)
			#await get_tree().create_timer(0.3).timeout
			free_puyo.emit()
			await update_cells([puyo_main, puyo_rotate], score)
		1:
			while is_clear(puyo_rotate.grid_pos + Vector2i(0, 1)):
				puyo_rotate.position += Vector2(0, 36)
				puyo_rotate.grid_pos += Vector2i(0, 1)
				await get_tree().create_timer(0.05).timeout
			add_puyo(puyo_rotate)
			score += 100
			base_scale.scale_amount = Vector2(score/100, score/100)
			base_scale.tween_scale()
			emit_signal("score_base", 100)
			while is_clear(puyo_main.grid_pos + Vector2i(0, 1)):
				puyo_main.position += Vector2(0, 36)
				puyo_main.grid_pos += Vector2i(0, 1)
				await get_tree().create_timer(0.05).timeout
			add_puyo(puyo_main)
			score += 100
			base_scale.scale_amount = Vector2(score/100, score/100)
			base_scale.tween_scale()
			emit_signal("score_base", 100)
			free_puyo.emit()
			await update_cells([puyo_rotate, puyo_main], score)
	return score

func _input(_event):
	if shit_happening == true:
		return
	if Input.is_action_pressed("ui_down"):
		if fall.time_left > 0.1:
			fall.start(0.1)

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
	if is_clear(puyo_main.grid_pos + Vector2i(0, 1)) and is_clear(puyo_rotate.grid_pos + Vector2i(0, 1)) and !shit_happening:
		puyo_main.position.y += 36
		puyo_rotate.position.y += 36
		puyo_main.grid_pos.y += 1
		puyo_rotate.grid_pos.y += 1
		fall.start(0.5)
	elif !shit_happening:
		shit_happening = true
		var score_pog = current_mult * await find_fall()
		total_score += score_pog
		update_score.scale_amount = Vector2(total_score/1000, total_score/1000)
		update_score.tween_scale()
		current_mult = 1
		emit_signal("score_updated", total_score)
		shit_happening = false
		
		free_puyo.emit()
		puyo_main = null
		puyo_rotate = null
		fall.start(0.5)
		spawn_puyos()
	else:
		fall.start(0.5)
