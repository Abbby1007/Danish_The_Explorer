extends Node2D

func _physics_process(delta):
	if global.one_enemies == 5:
		print("TELEPORT PLAYER")
		global.one_enemies == 0
		get_tree().change_scene_to_file("res://scenes/menu.tscn")
		
