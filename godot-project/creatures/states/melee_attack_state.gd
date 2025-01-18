extends State

@export var hitbox_offset: float
@export var hitbox_scene: PackedScene

var hitbox: Node

func on_enter() -> void:
	hitbox = hitbox_scene.instantiate()
	hitbox.position = creature.position + creature.facing_direction * hitbox_offset
	creature.get_parent().add_child(hitbox)

func on_exit() -> void:
	if hitbox:
		hitbox.queue_free()
