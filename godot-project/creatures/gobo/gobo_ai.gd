extends Controller

var next_update: int

# Gobos patrol between two targets
var targets: Array[Node2D]
var active_target: int

func bind(bind_target: Creature) -> void:
	super.bind(bind_target)

	for target in creature.get_tree().get_nodes_in_group("navigation_target"):
		if target is Node2D:
			targets.push_back(target)

func control() -> void:
	var target = targets[active_target]
	var distance = (target.position - creature.position).length()
	if distance < 100:
		active_target = (active_target+1)%targets.size()
	else:
		creature.navigate_to(target.position)
