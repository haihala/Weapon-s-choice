extends Controller

var next_update: int

func control() -> void:
	var player
	for critter in creature.get_tree().get_nodes_in_group("creature"):
		if critter.player_controlled:
			player = critter
			break


	var can_see_player = false

	if player:
		var space_state = creature.get_world_2d().direct_space_state
		# use global coordinates, not local to node
		var collision_mask = 1<<4
		var query = PhysicsRayQueryParameters2D.create(
			creature.global_position,
			player.global_position,
			collision_mask,
			[creature]
		)
		var result = space_state.intersect_ray(query)
		can_see_player = result.collider and result.collider == player
	
	if can_see_player:
		creature.facing_direction = (player.position - creature.position).normalized()
		if (player.position - creature.position).length() < 150:
			creature.host_strike()
			return
	else:
		var time = Time.get_ticks_msec()
		if time > next_update:
			next_update = time + 1000
			creature.facing_direction = Vector2.from_angle(randf_range(0, 2*PI))
	creature.walk()
