extends Node	# Player controller needs to extend Node to autoload
class_name Controller

var creature: Creature

func bind(bind_target: Creature) -> void:
	self.creature = bind_target

func control() -> void:
	pass
