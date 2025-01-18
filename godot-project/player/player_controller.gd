extends Controller

func control() -> void:
	direction = Input.get_vector(
		"move_left", 
		"move_right", 
		"move_up", 
		"move_down"
	).normalized()
