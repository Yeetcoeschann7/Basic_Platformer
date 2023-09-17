extends CharacterBody2D

const ACCELERATION = 0.3
const FRICTION = 0.15
const SPEED = 115.0
const JUMP_VELOCITY = -270.0
const WALL_PUSH = 200
const BUFFER_LENGTH = 10
const WALL_GRAVITY = 30
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = 950
var jumpReset = false
var buffer_frames = 0
var is_sliding = false


func _physics_process(delta):
	$ray_left/particles_left.emitting = false
	$ray_right/particles_right.emitting = false
	jump(delta)
	walk(delta)
	move_and_slide()
	wall_slide(delta)
	compute_particles()
	
func walk(_delta):
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = lerp(velocity.x, direction * SPEED, ACCELERATION)
	else:
		velocity.x = lerp(velocity.x, 0.0, FRICTION)

func jump(delta):
	if Input.is_action_just_pressed("jump"):
		buffer_frames = BUFFER_LENGTH
	
	if buffer_frames > 0:
		if is_on_floor() or jumpReset == true:
			velocity.y = JUMP_VELOCITY
		if $ray_right.is_colliding() and Input.is_action_pressed("left") and not is_on_floor(): 
			velocity.y = JUMP_VELOCITY
			velocity.x = -WALL_PUSH
			reset_buffer()
		if $ray_left.is_colliding() and Input.is_action_pressed("right") and not is_on_floor(): 
			velocity.y = JUMP_VELOCITY
			velocity.x = WALL_PUSH
			reset_buffer()
	if Input.is_action_just_released("jump") and not is_on_floor():
		if velocity.y < -100:
			velocity.y = -100
			
	velocity.y += gravity * delta
	buffer_frames -= 1

func reset_buffer():
	buffer_frames = 0
	
func wall_slide(delta):
	#Thx DevWorm! (https://www.youtube.com/@dev-worm)
	if is_on_wall() and !is_on_floor():
		if Input.is_action_pressed("left") or Input.is_action_pressed("right"):
			is_sliding = true
		else:
			is_sliding = false
	else:
		is_sliding = false
		
	if is_sliding:
		velocity.y += (WALL_GRAVITY * delta)
		velocity.y = min(velocity.y, WALL_GRAVITY)

func compute_particles():
	if not is_on_floor() and $ray_right.is_colliding():
		$ray_right/particles_right.emitting = true
	#elif is_on_floor() and velocity.x < -5:
		#$ray_right/particles_right.emitting = true
	else:
		$ray_right/particles_right.emitting = false
	
	if not is_on_floor() and $ray_left.is_colliding():
		$ray_left/particles_left.emitting = true
	#elif is_on_floor() and velocity.x > 5:
		#$ray_left/particles_left.emitting = true
	else:
		$ray_left/particles_left.emitting = false
