extends Node2D


"""
Handles scene change when the player enters it
"""

export(PackedScene) var next_level

func _on_Area2D_body_entered(body):
	print("Body entered %s" % body)
	LevelManager.goto(get_parent())
