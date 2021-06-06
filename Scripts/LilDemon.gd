extends KinematicBody2D
"""
Basic platformer control from Heartbeast 
for the purpose of showing Squash and Stretch
	https://www.youtube.com/watch?v=wETY5_9kFtA
Other platformers are available
"""

const UP = Vector2(0, -1)
const GRAVITY = 35
const SPEED = 700
const JUMP_HEIGHT = -1200

var motion = Vector2()
var motion_previous = Vector2()

var external_forces = []

func _physics_process(delta):
	motion.y += GRAVITY
	
	
	if Input.is_action_pressed("ui_left"):
		motion.x = -SPEED
	elif Input.is_action_pressed("ui_right"):
		motion.x = SPEED
	else:
		motion.x = 0
	
	
	if is_on_floor():
		if Input.is_action_just_pressed("ui_up"):
			motion.y = JUMP_HEIGHT
#		var r = rand_range(0.6,1.2)
#		motion.y = JUMP_HEIGHT * r
	
	
#	print("%s %s" % [external_forces, motion])
#	for i in range(external_forces.size(), -1, -1):
#		print(i)
	for force in external_forces:
		motion += force
	external_forces = []
	
	motion_previous = motion
	motion = move_and_slide(motion, UP, false)

	_handle_animations()

func _handle_animations():
	
	if motion.length() == 0:
		$AnimatedSprite.play("Idle")
	if motion.length() > 0:
		$AnimatedSprite.play("Walk")
	if motion.x < 0:
		$AnimatedSprite.flip_h = true
	if motion.x > 0:
		$AnimatedSprite.flip_h = false
	
	
#	$AnimatedSprite.playing = true
