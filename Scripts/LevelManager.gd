extends Node


"""
An Autoloaded singleton, that handles level transitions.
"""


func goto(scene):
	var scene_name = scene.name
	if scene_name.begins_with("Level"):
		# go to the next level
		var x = scene_name.lstrip("Level")
		print(x)
		var level_num = int( x ) + 1
		print("level num %s" % level_num)
		var new_level_scene = load("res://Scenes/Level%s.tscn" % level_num)
		var new_level = new_level_scene.instance()
		if new_level:
			get_node("/root").add_child(new_level)
			scene.queue_free()
	
	print("goto function called")
	pass
