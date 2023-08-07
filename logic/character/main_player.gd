extends CharacterBody2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = 980.0
var speed: float = 300.0
var jump_impulse: float = 200.0


func _physics_process(delta):
	var direction: Vector2 = Vector2.ZERO
	# apply gravity
	if !is_on_floor():
		velocity.y += gravity * delta
	# Get direction by player input
	direction.x = Input.get_axis('move_left', 'move_right')
	if direction.x != 0:
		velocity.x = speed * direction.x
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	move_and_slide()
