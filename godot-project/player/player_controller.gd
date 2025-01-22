extends Controller

func control() -> void:
	if !creature:
		# Player is dead
		return

	creature.walk(Input.get_vector(
		"move_left", 
		"move_right", 
		"move_up", 
		"move_down"
	).normalized())
	
	if Input.is_action_just_pressed("host_strike"):
		creature.host_strike()
	elif Input.is_action_just_pressed("sword_toss"):
		creature.sword_toss()
	elif Input.is_action_just_pressed("sword_swing"):
		creature.sword_swing()

# Player input gets special treatment, usually controllers can't read input this way
func _input(event: InputEvent) -> void:
	if !creature:
		# Player is dead
		return
	
	# This way both work, even at the same time technically
	# But if one is not touched, it won't be used.
	if event is InputEventMouseMotion:
		var cam = get_viewport().get_camera_2d()
		if cam:	# Not always present
			var mouse_position = cam.get_local_mouse_position() + cam.global_position
		
			creature.facing_direction = (mouse_position - creature.position).normalized()
	elif event is InputEventJoypadMotion:
		creature.facing_direction = Input.get_vector(
			"look_left",
			"look_right",
			"look_up",
			"look_down",
		).normalized()
