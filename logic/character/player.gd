extends CharacterBody2D
class_name Player

var gravity: float = 980.0
var speed: float = 200.0
var jump_impulse: float = 200.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite

func _ready():
	animated_sprite.play("run")

func _physics_process(delta):
	var direction: Vector2 = Vector2.ZERO
	
	# apply gravity
	if !is_on_floor():
		velocity.y += gravity * delta
		
	# Get direction by player input
	direction.x = Input.get_axis('move_left', 'move_right')
	if direction.x != 0:
		velocity.x = speed * direction.x
		
		# change sprite direction
		animated_sprite.flip_h = !isFaceRight(direction.x)
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	move_and_slide()
	
func isFaceRight(horizon_direction: int) -> bool:
	return true if horizon_direction > 0 else false 
