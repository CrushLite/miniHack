extends KinematicBody2D
class_name CrushableBody2D

"""
This class allows external forces to affect this body

Usage: 
	Override the crushed() method
	Other objects call add_force when they want this object to move.
"""

var _external_forces = []

func add_force(force: Vector2 = Vector2( 0, 0 )):
	_external_forces.append(force)

# This method gets called when the body is crushed by two opposing forces 
func crushed():
	print("Unimplemented Crushed body")
	pass

################################ Logic ##############################

func move_slide_and_crush(linear_velocity: Vector2, 
		up_direction: Vector2 = Vector2( 0, 0 ), 
		stop_on_slope: bool = false, 
		max_slides: int = 4, 
		floor_max_angle: float = 0.785398, 
		infinite_inertia: bool = true) -> Vector2:
	
	var output_vel = move_and_slide(linear_velocity, up_direction, stop_on_slope, floor_max_angle, infinite_inertia)
	
#	var collision_normals = _get_collision_normals()
#
#	for force in _external_forces:
#		output_vel = .move_and_slide(output_vel, up_direction, stop_on_slope, floor_max_angle, infinite_inertia)
#
#		_merge_dict(collision_normals, _get_collision_normals())
#		if _is_crushed(collision_normals):
#			crushed()
#			return output_vel
#	_external_forces = [] # clear the external forces array
	
	print("Moving %s %s" % [linear_velocity, output_vel])
	return output_vel

############################# Helpers #############################

func _get_collision_normals():
	var norms = {}
	for i in range(get_slide_count()):
		var col = get_slide_collision(i)
		norms[col] = 0
	return norms

static func _merge_dict(target, patch):
	for key in patch:
		target[key] = patch[key]

func _is_crushed(collision_normals):
	for col in collision_normals:
		for col2 in collision_normals:
			if col.dot(col2) == -1:
				return true
	


