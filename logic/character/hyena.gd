extends CharacterBody2D

signal player_detected

enum hyena_state {IDLE, CHASE, WANDER}

var move_speed: float = 250.0
var gravity: float = 980.0

# Hyena stats
var _state = hyena_state.IDLE
var detect_target_data: Dictionary = {'entity': null}

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite

func _physics_process(delta: float) -> void:
	match _state:
		hyena_state.IDLE: state_idle(delta)
		hyena_state.CHASE: state_chase(delta)

func state_idle(_delta: float) -> void:
	animation_player.play('idle')

func state_chase(_delta: float) -> void:
	var _entity: CharacterBody2D = detect_target_data['entity']
	var _current_position: Vector2 = self.global_position
	var _entity_position: Vector2 = _entity.global_position
	
	# Determine position of hyena againts entity target
	var _horizon_direction: float = -1.0 if _current_position.x > _entity_position.x else 1.0
	
	# Get distance of Hyena to entity object
	var _distance = abs(_current_position.distance_squared_to(_entity_position))
	var _distance_limit: float = 1024.0
	
	# Check if Hyena is near Entity, So Hyena can stop chase
	if _distance > _distance_limit:
		animation_player.play('run')
		velocity.x = move_speed * _horizon_direction
		sprite.flip_h = true if _horizon_direction > 0 else false
	else:
		velocity.x = move_toward(velocity.x, 0.0, move_speed)
		animation_player.play('idle')
	
	move_and_slide()
	

func _on_entity_entered(body: Node2D) -> void:
	if body is Player:
		if body.is_on_floor():
			detect_target_data['entity'] = body
			_state = hyena_state.CHASE


func _on_entity_exited(body: Node2D) -> void:
	if body is Player:
		detect_target_data['entity'] = null
		_state = hyena_state.IDLE
		
