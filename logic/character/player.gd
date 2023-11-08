extends CharacterBody2D
class_name Player

signal invincible

enum player_state {IDLE, RUN, JUMP, FALL, DEATH, BASIC_ATTACK}

var gravity: float = 980.0
var speed: float = 200.0
var jump_impulse: float = -350.0

# Entity State
var state = player_state.IDLE
var was_on_air: bool = false

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var effect_player: AnimationPlayer = $EffectPlayer
@onready var sprite: Sprite2D = $Sprite
@onready var remote_camera: RemoteTransform2D = $RemoteCamera
@onready var health: HealthSystem = $HealthController
@onready var hurtbox: Hurtbox = $Hitboxes/Hurtbox
@onready var invincible_timer: Timer = $Timers/InvincibleTimer

func _physics_process(delta) -> void:
	match state:
		# MOVE STATE
		player_state.IDLE: state_idle(delta)
		player_state.RUN: state_run(delta)
		player_state.JUMP: state_jump(delta)
		player_state.FALL: state_fall(delta)
		player_state.BASIC_ATTACK: state_basicattack()
		
func state_idle(delta: float) -> void:
	var direction: Vector2 = Vector2.ZERO
	direction.x = get_x_direction()
	
	# apply gravity
	if is_on_air():
		return handle_fall_state()
	
	if direction.x == 0:
		
		if is_on_floor() && Input.is_action_just_pressed('basic_attack'):
			state = player_state.BASIC_ATTACK
		
		if was_on_air:
			animation_player.play('land')
			await animation_player.animation_finished
			was_on_air = false
		else:
			animation_player.play('idle')
		
	# Exit state to Run state
	else: 
		state = player_state.RUN
	
	# Exit state to Jump state
	if is_on_floor() && Input.is_action_pressed("jump"):
		jump()
	
	move_and_slide()
	
func state_run(delta: float) -> void:
	var direction: Vector2 = Vector2.ZERO
	direction.x = get_x_direction()
	
	# apply gravity
	if is_on_air():
		handle_fall_state()
		return
	
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
		jump()
	
	move_and_slide()

func state_jump(delta: float) -> void:
	var direction: Vector2 = Vector2.ZERO
	direction.x = get_x_direction()
	
	# apply gravity
	if is_on_air():
		velocity.y += gravity * delta
	
	if direction.x != 0:
		velocity.x = speed * direction.x
		set_sprite_face(is_face_right(direction.x))
	else:
		velocity.x = move_toward(velocity.x, 0.0, speed)
	
	move_and_slide()
	
	# Check if player is fall
	if velocity.y > 0:
		# Exit state to Fall state
		state = player_state.FALL
		was_on_air = true
		animation_player.play('fall')
	
func state_fall(delta: float) -> void:
	var _direction: Vector2 = Vector2.ZERO
	_direction.x = get_x_direction()

	# Apply gravity	
	if is_on_air():
		velocity.y += gravity * delta
		
	if _direction.x != 0:
		velocity.x = speed * _direction.x
		set_sprite_face(is_face_right(_direction.x))
	else:
		velocity.x = move_toward(velocity.x, 0.0, speed)
		
	move_and_slide()
	
	if is_on_floor():
		# Exit state to Idle when player doesn't move
		if _direction.x == 0:
			state = player_state.IDLE
		else:
			state = player_state.RUN
			# set was_on_air to false directly because player try to run on land state after fall
		was_on_air = false

func state_death() -> void:
	await animation_player.animation_finished

func state_basicattack() -> void:
	var current_dir: int = -1 if sprite.flip_h else 1
	if current_dir > 0: 
		animation_player.play('basic_attack_right')
	else: 
		animation_player.play('basic_attack_left')
	
	if get_x_direction() != 0:
		state = player_state.RUN
	
	if Input.is_action_just_pressed('jump'):
		jump()
	
	await animation_player.animation_finished
	state = player_state.IDLE

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

func jump() -> void:
	velocity.y += jump_impulse
	state = player_state.JUMP
	animation_player.play('jump')

func set_sprite_face(_is_face_right: bool = true) -> void:
	sprite.flip_h = !_is_face_right

func handle_fall_state() -> void:
	was_on_air = true
	state = player_state.FALL
	animation_player.play('fall')

func connect_camera(_camera: Camera2D) -> void:
	var camera_path: NodePath = _camera.get_path()
	remote_camera.remote_path = camera_path
	
func _on_sensor_detect(area: Area2D) -> void:
	# player collect coin
	if area is Coin:
		Playerdata.collect_coin(1)

func _on_hurtbox_area_entered(hitbox: Hitbox) -> void:
	if hitbox.entity == 'mobs' && invincible_timer.is_stopped():
		if health.current_hp > 0:
			health.current_hp -= hitbox.damage
			if health.current_hp > 0:
				emit_signal('invincible')

func _on_health_depleted() -> void:
	state = null
	animation_player.play('death')
	$CollisionShape.set_deferred('disabled', true)
	await animation_player.animation_finished

func _on_invincible() -> void:
	invincible_timer.start()
	effect_player.play('invincible')

func _on_invincible_timer_timeout() -> void:
	effect_player.play('RESET')

