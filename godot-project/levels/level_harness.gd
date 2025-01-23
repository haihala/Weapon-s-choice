extends Node2D

@export var initial_level: PackedScene
@export var initial_creature: PackedScene
var active_level: PackedScene
var active_creature: PackedScene	# The one you entered the level with

func _ready() -> void:
	load_level(initial_level, initial_creature)

func load_level(level: PackedScene, player_scene: PackedScene) -> void:
	active_level = level
	active_creature = player_scene
	for child in $Active.get_children():
		child.queue_free()

	# Without this timeout, the previous scene is still present
	# This breaks a lot of stuff
	await get_tree().create_timer(0.01).timeout
	_spawn.call_deferred(player_scene)

func dynamic_level_load(level: String, player: Node2D) -> void:
	var player_scene = PackedScene.new()
	player_scene.pack(player)
	load_level(load(level), player_scene)

func _spawn(player_scene: PackedScene) -> void:
	var node = active_level.instantiate()
	$Active.add_child.call_deferred(node)
	spawn_player.call_deferred(player_scene)

func spawn_player(player_scene: PackedScene):
	var spawner = get_tree().get_nodes_in_group("player_spawner")[0]
	spawner.spawn(player_scene)

func reload() -> void:
	load_level(active_level, active_creature)
