extends Controller

var next_update: int

func control() -> void:
	var time = Time.get_ticks_msec()
	if time > next_update:
		next_update = time + 1000
		creature.facing_direction = Vector2.from_angle(randf_range(0, 2*PI))
	creature.walk()
