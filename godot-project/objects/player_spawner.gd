extends Node2D

@export var player_indicator: PackedScene
var to_spawn: PackedScene

func spawn(scene: PackedScene) -> void:
	to_spawn = scene
	var creature = to_spawn.instantiate()
	creature.position = position
	get_parent().add_child.call_deferred(creature)

	var indicator = player_indicator.instantiate()
	indicator.avatar = creature
	creature.following_indicator = indicator

	creature.possess()
	get_parent().add_child(indicator)
