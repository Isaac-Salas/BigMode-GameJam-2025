extends TextureRect

var planet_selected = null
signal game_start(game: String)
@onready var video_stream_player: VideoStreamPlayer = $TextureRect/VideoStreamPlayer
@onready var rich_text_label: RichTextLabel = $TextureRect/RichTextLabel
var puyoTXT = "INstructions:

connect 4 aliens of the same color touch side by side (not diagonal) in order to free them from odgo's grasp.

alternatively, you can clear a color of alien in the screen by connecting a bomb with another 3 aliens of the same color.

Controls:

move with the keyboard arrows left to right and press Z or X to rotate the piece clocwise or counterclockwise before placing.
You can also hold down to drop faster.

You'll lose if the spawning area gets covered by aliens and win when you fill the area on the right with corpses or allies."
var snakeTXT = "Controls: 

Use the arrows to move around the screen. 
But watch out, the walls can kill you if you touch them, however if you are powerful enough to break through you can reach new areas.
eat the offerings from the villagers or make a carnage in order to convice them to join you."
func _on_planet1_clicked():
	##puyoGame
	if not visible:
		show()
	var video = ResourceLoader.load("res://Assets/preview_video/puyo_video.ogv")
	if video:
		video_stream_player.stream = video
		video_stream_player.play()
	rich_text_label.text = puyoTXT
	planet_selected = 1

func _on_planet2_clicked():
	if not visible:
		show()
	video_stream_player.stop()
	planet_selected = 4
	rich_text_label.text = "WIP"
	
func _on_planet3_clicked():
	if not visible:
		show()
	video_stream_player.stop()
	rich_text_label.text = "WIP"
	planet_selected = 3

func _on_planet4_clicked():
	if not visible:
		show()
	var video = ResourceLoader.load("res://Assets/preview_video/snakerec.ogv")
	if video:
		video_stream_player.stream = video
		video_stream_player.play()
	rich_text_label.text = snakeTXT
	planet_selected = 2

func _on_start_button_pressed() -> void:
	print(planet_selected)
	match planet_selected:
		1:
			game_start.emit("Prism")
		2:
			game_start.emit("Leaf")
		3:
			game_start.emit("Swamp")
		4:
			game_start.emit("Egg")
