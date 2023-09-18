extends CharacterBody2D

const ACCELERATION = 0.3
const FRICTION = 0.15
const SPEED = 100.0
const JUMP_VELOCITY = -200.0
const WALL_PUSH = 180
var BUFFER_LENGTH = 10
const WALL_GRAVITY = 30
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = 525
var jumpReset = false
var buffer_frames = 0
var is_sliding = false
var no_move = ["left", "right"]
var next_land = false
var sec = 0



func _physics_process(delta):
	if sec < 10:
		sec += 1
	jump(delta)
	walk(delta)
	move_and_slide()
	wall_slide(delta)
	compute_particles()
	land_sfx()
	
func walk(_delta):
	var direction = Input.get_axis(no_move[0], no_move[1])
		
	if direction:
		velocity.x = lerp(velocity.x, direction * SPEED, ACCELERATION)
	else:
		velocity.x = lerp(velocity.x, 0.0, FRICTION)

func jump(delta):
	if Input.is_action_just_pressed("jump"):
		buffer_frames = BUFFER_LENGTH
		if (Input.is_action_pressed("left") or Input.is_action_pressed("right")) and !is_on_floor():
			if $ray_right.is_colliding(): 
				$jump_sfx.play()
				velocity.y = JUMP_VELOCITY
				velocity.x = -WALL_PUSH
				no_move = ["left", "none"]
				$move_timer.start()
				reset_buffer()
			if $ray_left.is_colliding(): 
				$jump_sfx.play()
				velocity.y = JUMP_VELOCITY
				velocity.x = WALL_PUSH
				no_move = ["none", "right"]
				$move_timer.start()
				reset_buffer()
	
	if buffer_frames > 0:
		if is_on_floor() or jumpReset == true:
			$jump_sfx.play()
			velocity.y = JUMP_VELOCITY

	if Input.is_action_just_released("jump") and not is_on_floor():
		if velocity.y < -100:
			velocity.y = -100
			
	velocity.y = min(velocity.y, 500)
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
		velocity.y += WALL_GRAVITY * delta
		velocity.y = min(velocity.y, WALL_GRAVITY)

func compute_particles():
	if not is_on_floor() and $ray_right.is_colliding():
		$ray_right/particles_right.emitting = true
	if not is_on_floor() and $ray_left.is_colliding():
		$ray_left/particles_left.emitting = true
		
func land_sfx():
	if !is_on_floor() and sec > 5:
		next_land = true
	if next_land == true and is_on_floor():
		$AnimationPlayer.play("squish")
		$land_sfx.play()
		next_land = false

func _on_move_timer_timeout():
	no_move = ["left", "right"]
