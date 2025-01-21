extends Node2D
class_name PossessionIndicator

@export var initial_creature: PackedScene
var avatar: Node2D

func _ready() -> void:
	avatar = initial_creature.instantiate()
	avatar.position = position
	avatar.following_indicator = self
	avatar.possess()
	get_parent().add_child.call_deferred(avatar)

func _process(_delta: float) -> void:
	if is_instance_valid(avatar):
		position = avatar.position

func move_to(target: Node2D) -> void:
	avatar = target
	target.following_indicator = self

	if target is Creature:
		visible = true
	else:
		visible = false
