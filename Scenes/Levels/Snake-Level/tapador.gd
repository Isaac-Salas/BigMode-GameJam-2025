extends Node2D
@onready var animation_player = $AnimationPlayer
@onready var area_2d = $Area2D
@onready var allinside : Array




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_2d_area_entered(area):
	if area.is_in_group("Hut"):
		allinside.append(area)
		#print(allinside)
	if area.is_in_group("SnakeArea"):
		for i in allinside:
			var hut : SlaveHut = i.get_parent()
			hut.startspawn()
		animation_player.play("new_animation")
		await animation_player.animation_finished
		self.queue_free()
