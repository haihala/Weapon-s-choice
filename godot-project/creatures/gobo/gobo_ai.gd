extends Controller

var player_position: Vector2

func control() -> void:	
	var player = find_player()
	if can_see(player):
		player_position = player.position
		if (player.position - creature.position).length() < 150:
			creature.host_strike()
			return

	if player_position:
		creature.facing_direction = (player_position - creature.position).normalized()
		creature.walk()

