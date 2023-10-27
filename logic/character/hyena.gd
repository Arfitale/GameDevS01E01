extends CharacterBody2D

signal player_detected
signal take_damage

enum hyena_state {IDLE, CHASE, WANDER, ATTACK}

var move_speed: float = 150.0
var gravity: float = 980.0

# Hyena stats
var _state = hyena_state.IDLE
var detector_data: Dictionary = {'playerSensor': null, 'attackSensor': null}

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite
@onready var chase_delay_timer: Timer = $Timers/ChaseDelayTimer
@onready var basic_attack_delay_timer: Timer = $Timers/BasicAttackDelayTimer

func _physics_process(delta: float) -> void:
	match _state:
		hyena_state.IDLE: state_idle(delta)
		hyena_state.CHASE: state_chase(delta)
		hyena_state.ATTACK: state_attack(delta)

func state_idle(_delta: float) -> void:
	animation_player.play('idle')

	velocity.x = move_toward(velocity.x, 0, move_speed)
	velocity.y += gravity * _delta
	move_and_slide()

func state_chase(_delta: float) -> void:
	var _player: CharacterBody2D = detector_data['playerSensor']
	
	if _player.is_on_floor():
		var _direction: float = round(self.global_position.direction_to(_player.global_position).x)
		velocity.x = move_speed * _direction
		animation_player.play('run')
		sprite.flip_h = true if _direction > 0 else false
	
	velocity.y += gravity * _delta
	move_and_slide()

func state_attack(_delta: float) -> void:
	var _player: CharacterBody2D = detector_data['attackSensor']
	
	if basic_attack_delay_timer.is_stopped():
		if sprite.flip_h:
			animation_player.play('basic_attack_right')
		else:
			animation_player.play('basic_attack_left')
		basic_attack_delay_timer.start()
	
	velocity.x = Vector2.ZERO.x
	velocity.y += gravity * _delta
	move_and_slide()
	
	# Exit state
	if !detector_data['attackSensor']:
		if detector_data['playerSensor']:
			_state = hyena_state.CHASE
		else:
			_state = hyena_state.IDLE

func on_entity_detected(body: Node2D) -> void:
	if body is Player:
		detector_data['playerSensor'] = body
		chase_delay_timer.start()

func on_entity_exited(body: Node2D) -> void:
	if body is Player:
		detector_data['playerSensor'] = null
		_state = hyena_state.IDLE

func _on_attack_sensor_body_entered(body: Node2D) -> void:
	if body is Player:
		detector_data['attackSensor'] = body
		_state = hyena_state.ATTACK

func _on_attack_sensor_body_exited(body: Node2D) -> void:
	if body is Player:
		detector_data['attackSensor'] = null

# When chase timer is zero then Hyena chase player
func _on_chase_delay_timer_timeout() -> void:
	if detector_data['playerSensor']:
		_state = hyena_state.CHASE
