extends State

@export var hitbox_offset: float
@export var hitbox_scene: PackedScene
@export_range(1, 10) var hitbox_scale: float = 1.0
@export var startup_frames: int
@export_range(0.0, 1.0) var active_for: float = 0.1
@export var lunge_distance: float

var hitbox: Node
var has_activated = false

func on_tick() -> void:
	super.on_tick()
	if not has_activated and creature.get_node("Sprite").frame == startup_frames:
		activate_hitbox()

func activate_hitbox() -> void:
	creature.force_movement(lunge_distance * creature.facing_direction, 0.5)
	has_activated = true
	if hitbox_scene:
		hitbox = hitbox_scene.instantiate()
		hitbox.position = creature.facing_direction * hitbox_offset
		hitbox.rotation = creature.facing_direction.angle()
		hitbox.register_owner(creature)
		hitbox.scale.x = hitbox_scale
		hitbox.scale.y = hitbox_scale
		creature.add_child(hitbox)
		if active_for > 0:
			await get_tree().create_timer(active_for).timeout
			if is_instance_valid(hitbox):
				hitbox.queue_free()

func on_exit() -> void:
	super.on_exit()
	if is_instance_valid(hitbox):
		hitbox.queue_free()
	has_activated = false
