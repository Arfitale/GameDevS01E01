extends Node2D
class_name PlayerData

signal update_score

var gamedata: Dictionary = {
	"score": 0
}

# methods when player collect coin
func collect_coin(val: int) -> void:
	emit_signal('update_score', val)

func _on_update_score(new_val: int) -> void:
	gamedata.score += new_val
