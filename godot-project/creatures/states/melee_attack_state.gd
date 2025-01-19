extends State

@export var hitbox_offset: float
@export var hitbox_scene: PackedScene
@export_range(1, 10) var hitbox_scale: float = 1.0
@export var startup_frames: int
@export var lunge_distance: float

var hitbox: Node
var has_activated = false

func on_tick() -> void:
	super.on_tick()
	if not has_activated and creature.get_node("Sprite").frame == startup_frames:
		activate_hitbox()

func activate_hitbox() -> void:
	if hitbox_scene:
		hitbox = hitbox_scene.instantiate()
		hitbox.position = creature.facing_direction * hitbox_offset
		hitbox.rotation = creature.facing_direction.angle()
		hitbox.register_owner(creature)
		hitbox.scale.x = hitbox_scale
		hitbox.scale.y = hitbox_scale
		creature.add_child(hitbox)
	creature.force_movement(lunge_distance * creature.facing_direction, 0.5)
	has_activated = true

func on_exit() -> void:
	super.on_exit()
	if is_instance_valid(hitbox):
		hitbox.queue_free()
	has_activated = false
