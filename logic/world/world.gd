extends Node2D
class_name World

@onready var camera: Camera2D = $Camera
@onready var player_node: Node2D = $PlayerNode

var player: CharacterBody2D = null

func _ready() -> void:
	# Check if player exist in the main scene
	var is_player_exist: bool = player_node.has_node('Player')
	if is_player_exist: 
		player = player_node.get_node('Player')
		set_camera(player)
		
func set_camera(_node: Variant) -> void:
	_node.connect_camera(camera)
