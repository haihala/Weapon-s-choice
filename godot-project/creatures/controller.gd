extends Node	# Player controller needs to extend Node to autoload
class_name Controller

var creature: Creature

func bind(bind_target: Creature) -> void:
	self.creature = bind_target

func control() -> void:
	pass

func find_player() -> Creature:
	for critter in creature.get_tree().get_nodes_in_group("creature"):
		if critter.player_controlled:
			return critter
	return null

func can_see(target: Node2D) -> bool:
	if target:
		var space_state = creature.get_world_2d().direct_space_state
		# use global coordinates, not local to node
		var collision_mask = 1<<4
		var query = PhysicsRayQueryParameters2D.create(
			creature.global_position,
			target.global_position,
			collision_mask,
			[creature]
		)
		var result = space_state.intersect_ray(query)
		return result.collider and result.collider == target
	return false
