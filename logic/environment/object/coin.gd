extends Area2D

func _on_body_entered(body: Node2D) -> void:
	# if player collect coin
	if body is Player:
		queue_free()
