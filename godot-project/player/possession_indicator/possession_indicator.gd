extends Node2D

func _process(_delta: float) -> void:
	for child in get_parent().get_children():
		if child is Creature and child.player_controlled:
			position = child.position
			visible = true
			return

	# None of the creatures are player controlled
	# Sword throw in progress
	# Hide indicator
	visible = false
