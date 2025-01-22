extends Node2D

@export var player_indicator: PackedScene
@export var to_spawn: PackedScene

func _ready() -> void:
	var existing_player = null
	for creat in get_tree().get_nodes_in_group("creature"):
		if creat.player_controlled:
			existing_player = creat

	if to_spawn:
		# Spawn new player
		# Likely first in a series of levels
		if is_instance_valid(existing_player):
			existing_player.queue_free()

		var creature = to_spawn.instantiate()
		creature.position = position
		get_parent().add_child.call_deferred(creature)

		var indicator = player_indicator.instantiate()
		indicator.avatar = creature
		creature.following_indicator = indicator

		creature.possess()
		get_parent().add_child.call_deferred(indicator)
	else:
		# Move existing player here
		# Continuation level
		existing_player.position = position
