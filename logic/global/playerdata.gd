extends CharacterBody2D
class_name PlayerData

signal update_score

var gamedata: Dictionary = {
	"score": 0
}

func collect_coin(val: int) -> void:
	emit_signal('update_score')
