extends Node2D
class_name PossessionIndicator

var avatar: Node2D

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
