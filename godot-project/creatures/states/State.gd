extends Node
class_name State

@export var front_animation: String
@export var back_animation: String

@export var duration: float

# This assumes that the states are all in the state container under the mook
@onready var creature: Creature = get_parent().get_parent()

func on_enter() -> void:
	pass

func on_tick() -> void:
	pass

func on_exit() -> void:
	pass
