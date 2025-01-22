extends Node2D

@export var initial_level: PackedScene
var active_level: PackedScene

func _ready() -> void:
	load_level(initial_level)

func load_level(level: PackedScene) -> void:
	active_level = level
	var node = active_level.instantiate()
	for child in $Active.get_children():
		child.queue_free()
	$Active.add_child(node)

func dynamic_level_load(level: String, player: Node2D) -> void:
	player.reparent(self)
	load_level(load(level))
	player.reparent($Active)
