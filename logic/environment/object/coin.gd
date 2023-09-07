extends Area2D
class_name Coin

func _on_body_entered(body: Node2D) -> void:
	# if player collect coin
	if body is Player:
		queue_free()
