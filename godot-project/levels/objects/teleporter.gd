extends Node2D

# Use a target node to easier adjust location
@export var target: Node2D

func on_collision(body: Node2D) -> void:
	# Only transfer player controlled entities
	if body.player_controlled:
		body.position = target.position
