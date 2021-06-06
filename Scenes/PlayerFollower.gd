extends Camera2D

export(NodePath) var target_path


func _process(delta):
	position.x = get_node(target_path).position.x
	pass
