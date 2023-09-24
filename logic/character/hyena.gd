extends CharacterBody2D

enum hyena_state {IDLE, CHASE, WANDER}

var move_speed: float = 250.0
var gravity: float = 980.0
var move_dir: int = 1

# Hyena stats
var _state = hyena_state.IDLE

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite

func _physics_process(delta: float) -> void:
	match _state:
		hyena_state.IDLE: state_idle(delta)

func state_idle(_delta: float) -> void:
	animation_player.play('idle')
