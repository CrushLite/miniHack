extends KinematicBody2D
#extends CrushableBody2D

const UP = Vector2(0, -1)
const GRAVITY = 35
const SPEED = 500
const JUMP_HEIGHT = -800

export var floating_speed = 500

var motion = Vector2()
var motion_previous = Vector2()
var is_on_wall = false


func _physics_process(delta):
	if $RayCastLeft.is_colliding():
		if not is_on_wall:
			motion.y = 0
		is_on_wall = "left"
		
	elif $RayCastRight.is_colliding():
		if not is_on_wall:
			motion.y = 0
		is_on_wall = "right"
	else:
		is_on_wall = false
	
	if is_on_wall:
		if motion.y > 0:
			motion.y += GRAVITY*0.01
		else:
			motion.y += GRAVITY
		if Input.is_action_just_pressed("ui_up"):
			motion.y = JUMP_HEIGHT
			if is_on_wall == "right":
				motion.x -= SPEED*10
				print("RIGHT")
			elif is_on_wall == "left":
				motion.x += SPEED*10
				
		# ADD: New wall animation
	else:
		motion.y += GRAVITY
	
	
	
	
	if Input.is_action_pressed("ui_left"):
		motion.x -=SPEED
	elif Input.is_action_pressed("ui_right"):
		motion.x +=SPEED
	elif is_on_floor():
		motion.x = 0
	
	
	if is_on_floor():
		if Input.is_action_just_pressed("ui_up"):
			motion.y = JUMP_HEIGHT
#		var r = rand_range(0.6,1.2)
#		motion.y = JUMP_HEIGHT * r
	
#	print("%s %s" % [external_forces, motion])
#	for i in range(external_forces.size(), -1, -1):
#		print(i)
#	for force in external_forces:
#		motion += force
#	external_forces = []
	
	motion.x = clamp(motion.x, -SPEED, SPEED)
	motion_previous = motion
#	motion = move_slide_and_crush(motion, UP, false)
	motion = move_and_slide(motion, UP, false)
	
	_handle_animations()


func crushed():
	position = Vector2(400,400)

func die():
	position = Vector2(400,400)
#	queue_free()

func _handle_animations():
	
	if is_on_floor():
		if motion.length() == 0:
			$AnimatedSprite.play("Idle")
		if motion.length() > 0:
			$AnimatedSprite.play("Walk")
	elif is_on_wall:
		$AnimatedSprite.play("Wall")
	else:
		if abs(motion.y) < floating_speed:
			$AnimatedSprite.play("Floating?")
		else:
			if motion.y < 0: # rising
				$AnimatedSprite.play("Launching")
			else:
				$AnimatedSprite.play("Falling")
				
				
	
	if motion.x < 0:
		$AnimatedSprite.flip_h = true
	if motion.x > 0:
		$AnimatedSprite.flip_h = false
	
	
#	$AnimatedSprite.playing = true
