extends Node2D

# Use a target node to easier adjust location
@export var scene_target: String

func _ready() -> void:
	assert(scene_target != "")

func on_collision(body: Node2D) -> void:
	# Only transfer player controlled entities
	if body.player_controlled:
		var harness = get_tree().get_nodes_in_group("level_harness")[0]
		harness.dynamic_level_load(scene_target, body)
