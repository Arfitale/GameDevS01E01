extends CharacterBody2D

signal player_detected

enum hyena_state {IDLE, CHASE, WANDER}

var move_speed: float = 250.0
var gravity: float = 980.0

# Hyena stats
var _state = hyena_state.IDLE
var detector_data: Dictionary = {'playerSensor': null}

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite

func _physics_process(delta: float) -> void:
	match _state:
		hyena_state.IDLE: state_idle(delta)
		hyena_state.CHASE: state_chase(delta)

func state_idle(_delta: float) -> void:
	animation_player.play('idle')

	velocity.x = move_toward(velocity.x, 0, move_speed)
	velocity.y += gravity * _delta
	move_and_slide()

func state_chase(_delta: float) -> void:
	var _player: CharacterBody2D = detector_data['playerSensor']
	
	if _player.is_on_floor():
		var _distance: float = self.global_position.distance_to(_player.global_position)
		var _direction: float = round(self.global_position.direction_to(_player.global_position).x)
		
		
		if _distance > 32:
			velocity.x = move_speed * _direction
			animation_player.play('run')
			sprite.flip_h = true if _direction > 0 else false
		else:
			velocity.x = move_toward(velocity.x, 0, move_speed)
	
	velocity.y += gravity * _delta
	move_and_slide()

func on_entity_detected(body: Node2D) -> void:
	if body is Player:
		detector_data['playerSensor'] = body
		_state = hyena_state.CHASE


func on_entity_exited(body: Node2D) -> void:
	if body is Player:
		detector_data['playerSensor'] = null
		_state = hyena_state.IDLE
