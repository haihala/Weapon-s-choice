extends Node	# Player controller needs to extend Node to autoload
class_name Controller

var direction: Vector2
var creature: Creature

func bind(creature: Creature) -> void:
	self.creature = creature

func control() -> void:
	pass
