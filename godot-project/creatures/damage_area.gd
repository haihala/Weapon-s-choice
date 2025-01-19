extends Node2D

@export var damage: int
var blacklist: Array[Node2D]

func _ready() -> void:
	blacklist.push_back(self)
	blacklist.push_back(get_parent())

func register_owner(creature: Creature) -> void:
	blacklist.push_back(creature)

func on_hit(body: Node2D) -> void:
	if body is not Creature or body in blacklist:
		return
	print(body)
	body.take_damage(damage, global_position)
