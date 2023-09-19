extends CharacterBody2D

const ACCELERATION = 0.3
const FRICTION = 0.15
const SPEED = 100.0 * 4
const JUMP_VELOCITY = -200.0 * 4
const WALL_PUSH = 180 * 4
var BUFFER_LENGTH = 10
const WALL_GRAVITY = 30 * 4
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = 525 * 4
var jumpReset = false
var buffer_frames = 0
var is_sliding = false
var no_move = ["left", "right"]
var next_land = false
var sec = 0
var prev_x = self.position.x
var prev_y = self.position.y
var spawn = self.position
var was_on_floor = false

func _ready():
	spawn = self.position

func _physics_process(delta):
	prev_y = self.position.y
	if sec < 10:
		sec += 1
	if !is_on_floor() and !is_sliding and sec > 5:
		$AnimationPlayer.play("stretch")
	if is_on_floor():
		was_on_floor = true
	else:
		was_on_floor = false
		
	move_and_slide()
	jump(delta)
	walk(delta)
	wall_slide(delta)
	compute_particles()
	land_sfx()
	ground_particles()
	if (was_on_floor == true and is_on_floor() == false) and self.position.y > prev_y:
		$coyote_timer.start()
	
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
		if is_on_floor() or not $coyote_timer.is_stopped():
			$jump_sfx.play()
			velocity.y = JUMP_VELOCITY

	if Input.is_action_just_released("jump") and not is_on_floor():
		if velocity.y < -100:
			velocity.y = -100
			
	velocity.y = min(velocity.y, 800)
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

func ground_particles():
	if velocity.x >= 200 and is_on_floor() and (self.position.x != prev_x):
		$ray_left/particles_left.emitting = true
	if velocity.x <= -200 and is_on_floor() and (self.position.x != prev_x):
		$ray_right/particles_right.emitting = true
	prev_x = self.position.x
	
	if (velocity.y < 200 and velocity.y > -200) and !is_on_floor():
		$AnimationPlayer.play("still")

func _on_move_timer_timeout():
	no_move = ["left", "right"]


func _on_hazard_area_body_entered(body):
	if body.name == "tile_map":
		self.position = spawn
