extends Area2D

@export var damage: int

func _on_body_entered(body: Node2D) -> void:
	if body == self or body == get_parent():
		return
	print(body)
	body.take_damage(damage, global_position)
