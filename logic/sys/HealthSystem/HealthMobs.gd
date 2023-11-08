extends HealthSystem

@onready var health_bar: ProgressBar = $HealthBar
@onready var show_timer: Timer = $ShowTimer

func _ready() -> void:
	health_init()
	health_bar.visible = false

func set_current_hp(new_hp: int) -> void:
	health_bar.visible = true
	show_timer.start()
	
	current_hp = new_hp
	current_hp = clamp(current_hp, 0, max_health)
	emit_signal('changed', current_hp)
	
	if current_hp == 0:
		emit_signal('depleted')

func _on_show_timer_timeout() -> void:
	health_bar.visible = false
