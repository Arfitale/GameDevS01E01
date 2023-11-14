extends Area2D
class_name Hurtbox

@export_enum('player', 'mobs') var entity: String
@export var overlap_detection: bool = false

@onready var collision_shape: CollisionShape2D = $CollisionShape
@onready var trigger_delay: Timer = $TriggerDelay

func _monitoring_refresh() -> void:
	set_deferred('monitoring', false)
	set_deferred('monitoring', true)

func _on_area_entered(hitbox: Hitbox) -> void:
	if overlap_detection:
		trigger_delay.start()

func _on_trigger_delay_timeout() -> void:
	_monitoring_refresh()

func _disable_monitoring() -> void:
	set_deferred('monitoring', false)
