extends Node2D

func _ready() -> void:
	var player_health_bar: ProgressBar = $UILayer/GameUI/HealthBar
	var health_controller: Node2D = $WorldLayer/World/PlayerNode/Player/HealthController
	
	health_controller.connect('max_health_changed', player_health_bar.set_max)
	health_controller.connect('changed', player_health_bar.set_value)
	health_controller.health_init()
