extends Node2D

signal max_health_changed
signal changed
signal depleted

@export var max_health: int = 10 : set = set_max_health
@onready var current_hp: int = max_health : set = set_current_hp

func _ready() -> void:
	health_init()

func health_init() -> void:
	emit_signal('max_health_changed', max_health)
	emit_signal('changed', current_hp)

func set_max_health(new_max: int) -> void:
	max_health = new_max
	max_health = max(1, max_health)
	emit_signal('max_health_changed', max_health)

func set_current_hp(new_hp: int) -> void:
	current_hp = new_hp
	current_hp = clamp(current_hp, 0, max_health)
	emit_signal('changed', current_hp)
	
	if current_hp == 0:
		emit_signal('depleted')
