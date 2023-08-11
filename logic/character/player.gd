extends CharacterBody2D
class_name Player

enum player_state {IDLE, RUN, JUMP, FALL}

var gravity: float = 980.0
var speed: float = 200.0
var jump_impulse: float = -300.0

var state = player_state.RUN

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _physics_process(delta) -> void:
	match state:
		player_state.IDLE: state_idle(delta)
		player_state.RUN: state_run(delta)
		player_state.JUMP: state_jump(delta)
		player_state.FALL: state_fall(delta)
	
func state_idle(delta: float) -> void:
	var direction: Vector2 = Vector2.ZERO
	direction.x = get_x_direction()
	
	# apply gravity
	if !is_on_floor():
		velocity.y += gravity * delta
	
	if direction.x == 0:
		animation_player.play('idle')
		
	# Exit state to Run state
	else: 
		state = player_state.RUN
	
	# Exit state to Jump state
	if is_on_floor() && Input.is_action_pressed("jump"):
		state = player_state.JUMP
	
	move_and_slide()

func state_run(delta: float) -> void:
	var direction: Vector2 = Vector2.ZERO
	direction.x = get_x_direction()
	
	# apply gravity
	if !is_on_floor():
		velocity.y += gravity * delta
	
	if direction.x != 0:
		velocity.x = speed * direction.x
		
		# Handle run animation
		handle_run_anim(direction.x)
	
	# Exit to Idle state
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		state = player_state.IDLE
	
	# Exit to Jump state
	if is_on_floor() && Input.is_action_pressed("jump"):
		state = player_state.JUMP
	
	move_and_slide()

func state_jump(delta: float) -> void:
	pass

func state_fall(delta: float) -> void:
	pass

func is_face_right(_horizon_direction: int) -> bool:
	return true if _horizon_direction > 0 else false 

func is_on_air() -> bool:
	return !is_on_floor()

func get_x_direction() -> float:
	return Input.get_axis('move_left', 'move_right')

func handle_run_anim(_horizon_direction: int) -> void:
	if _horizon_direction > 0:
		animation_player.play('run_right')
	else: animation_player.play('run_left')

func handle_jump_anim() -> void:
	animation_player.play('jump')
