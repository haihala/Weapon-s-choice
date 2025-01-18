extends Node2D


func _on_area_2d_body_entered(body: Node2D) -> void:
	# Layers are setup in a way where this can't collide with anything that can't take damage
	body.take_damage(1, position)
