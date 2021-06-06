extends Node2D


export var move_speed = 100
var patrol_points
var patrol_index = 0
var velocity = Vector2.ZERO

export (int, 0, 200) var push = 70

func _ready():
	$KinematicBody2D.position = $Path2D/PathFollow2D.position
	patrol_points = $Path2D.curve.get_baked_points()

func _physics_process(delta):
	var target = patrol_points[patrol_index]
	if $KinematicBody2D.position.distance_to(target) < 1:
		patrol_index = wrapi(patrol_index + 1, 0, patrol_points.size())
		target = patrol_points[patrol_index]
	velocity = (target - $KinematicBody2D.position).normalized() * move_speed
	
#	velocity = $KinematicBody2D.move_and_slide(velocity)
	var collision = $KinematicBody2D.move_and_collide(velocity * delta, true, true, true)
	if not collision:
		# TODO/BUG: when the player is moving into the platform he can fight it
		$KinematicBody2D.move_and_collide(velocity * delta)
#		$KinematicBody2D.position += velocity * delta
	else:
#		# move the colliding object along the normal based on collision.remainder
		var player = collision.collider
			
#		print(player.name)
		var force = collision.normal * collision.remainder.abs()
#		print(force, collision.normal)
		
		# BUG: This code will kill the player if he is standing on top of a platform
		#      and also collides with a wall.
		
		if player is KinematicBody2D:
			
			var player_collision = player.move_and_collide(-force)
			if player_collision:
				var dot_prod = collision.normal.dot(player_collision.normal)
				if dot_prod == -1:
					# we've smooshed
					print("Collided: %s %s %s" % [player_collision.normal, collision.normal, dot_prod])
					player.die()
#			player.position += -force
			
			$KinematicBody2D.position += collision.travel + collision.remainder
#			$KinematicBody2D.move_and_collide(velocity * delta)
		else: # like the tilemap
			set_process(false)
			pass
#		$KinematicBody2D.move_and_collide(velocity * delta)
#		collision.collider.position += collision.normal * collision.remainder
	
	
	#then move the crusher
	
#	for i in $KinematicBody2D.get_slide_count():
#		var collision = $KinematicBody2D.get_slide_collision(i)
#		if collision.collider.is_in_group("bodies"):
#			print("%s" % collision.collider.name)
#			_apply_force(collision.collider, -collision.normal * push * velocity.length())
##			collision.collider.apply_central_impulse(-collision.normal * push)

func _apply_force(kb : KinematicBody2D, force : Vector2):
	# applies a force to the body
#	if kb.get("external_forces"):
	kb.external_forces.append(force)
	print("adding force")
