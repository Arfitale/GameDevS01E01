extends Area2D
class_name LevelShifter

@export var next_level: PackedScene = null

func _on_body_entered(body: Node2D) -> void:
	if body is Player && next_level:
		get_tree().change_scene_to_packed(next_level)
