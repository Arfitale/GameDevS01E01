extends CharacterBody2D
class_name Player

enum player_state {IDLE, RUN}

var gravity: float = 980.0
var speed: float = 200.0
var jump_impulse: float = -300.0
var state = player_state.RUN

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _physics_process(delta) -> void:
	match state:
		player_state.IDLE: state_idle(delta)
		player_state.RUN: state_run(delta)
	
func state_idle(delta: float) -> void:
	var direction: Vector2 = Vector2.ZERO
	direction.x = Input.get_axis('move_left', 'move_right')
	
	# apply gravity
	if !is_on_floor():
		velocity.y += gravity * delta
	
	if direction.x == 0:
		animation_player.play('idle')
	
	# Exit Idle state to Run state
	else: 
		state = player_state.RUN
	
	move_and_slide()

func state_run(delta: float) -> void:
	var direction: Vector2 = Vector2.ZERO
	
	# apply gravity
	if !is_on_floor():
		velocity.y += gravity * delta
	
	# Get direction by player input
	direction.x = Input.get_axis('move_left', 'move_right')
	if direction.x != 0:
		velocity.x = speed * direction.x
		
		# Handle run animation
		handle_run_anim(direction.x)
	
	# Exit Run state to Idle state
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		state = player_state.IDLE
	
	# handle jump
	if is_on_floor() && Input.is_action_pressed("jump"):
		jump(jump_impulse) 
	
	move_and_slide()


func jump(_jump_impulse: float) -> void:
	velocity.y += _jump_impulse

func is_face_right(_horizon_direction: int) -> bool:
	return true if _horizon_direction > 0 else false 

func handle_run_anim(_horizon_direction: int) -> void:
	if _horizon_direction > 0:
		animation_player.play('run_right')
	else: animation_player.play('run_left')
