extends CharacterBody2D

const ACCELERATION = 0.4
const FRICTION = 0.15
const SPEED = 115.0
const JUMP_VELOCITY = -270.0
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	jump(delta)
	walk()

	move_and_slide()
	
func walk():
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = lerp(velocity.x, direction * SPEED, ACCELERATION)
	else:
		velocity.x = lerp(velocity.x, 0.0, FRICTION)

func jump(delta):
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	if Input.is_action_just_released("jump")  and not is_on_floor():
		if velocity.y < -100:
			velocity.y = -100
	velocity.y += gravity * delta
