extends CharacterBody2D

var move_speed: float = 250.0
var gravity: float = 980.0
var move_dir: int = 1

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite

func _process(delta: float) -> void:
	if Input.is_action_just_pressed('TestKey'):
		move_dir = move_dir * -1
		sprite.flip_h = true if move_dir > 0 else false
		

func _physics_process(delta: float) -> void:
	animation_player.play('run')
	velocity.x = move_speed * move_dir
	velocity.y += gravity * delta
	move_and_slide()
