extends Node2D

var previously_hit: Array[Creature]

func on_hit(creature: Node2D, damage: int):
	if creature is not Creature or creature in previously_hit:
		return

	previously_hit.push_back(creature)
	creature.take_damage(damage, position)

func register_owner(creature: Creature) -> void:
	previously_hit.push_back(creature)

func _process(_delta: float) -> void:
	var timer_phase = $Timer.time_left / $Timer.wait_time
	var phase = (1-timer_phase) * 0.7 + 0.3
	$Sprite.material.set_shader_parameter("phase", phase)

func finish() -> void:
	queue_free()
