extends Area2D
class_name Hitbox

@export_enum('player', 'mobs') var entity: String
@export var damage: int = 0
@export var overlap_detection: bool = false

@onready var collision_shape: CollisionShape2D = $CollisionShape
@onready var trigger_delay: Timer = $TriggerDelay

func _collision_refresh() -> void:
	set_deferred('monitoring', false)
	set_deferred('monitoring', true)

func _on_area_entered(hitbox: Hitbox) -> void:
	if overlap_detection:
		trigger_delay.start()

func _on_trigger_delay_timeout() -> void:
	_collision_refresh()
