extends CharacterBody2D
class_name Creature

@export var player_controlled: bool
@export var ai_controller: GDScript
var ai: Controller
var controller: Controller

@export var health = 2
@export var speed = 300
var navigation_target: Vector2

@export var idle_state: State
@export var walk_state: State
@export var host_strike_state: State
@export var sword_swing_state: State
var active_state: State

var forced_movement: Vector2
var facing_direction: Vector2

func _ready():
	activate_state(idle_state)
	
	ai = ai_controller.new()
	ai.bind(self)
	
	if player_controlled:
		possess()
	else:
		controller = ai

func _physics_process(_delta: float) -> void:
	if can_act():
		controller.control()
	elif !$MovementTimer.is_stopped():
		# Getting hit
		# This way it slows down over the timer and is normalized 1-0
		velocity = forced_movement * $MovementTimer.time_left / $MovementTimer.wait_time
	active_state.on_tick()
	update_sprite_facing()
	move_and_slide()

func can_act() -> bool:
	return $HitTimer.is_stopped() and not active_state.blocking

func get_animation(state: State = active_state) -> String:
	return state.front_animation if facing_direction.y > 0 else state.back_animation

func update_sprite_facing() -> void:
	$Sprite.flip_h = facing_direction.x < 0
	var animation = get_animation()
	if animation:
		var current_frame = $Sprite.get_frame()
		var current_progress = $Sprite.get_frame_progress()
		$Sprite.play(animation)
		$Sprite.set_frame_and_progress(current_frame, current_progress)

func idle() -> void:
	if active_state != idle_state:
		activate_state(idle_state)
		velocity = Vector2.ZERO

func walk(direction: Vector2 = facing_direction) -> void:
	if direction == Vector2.ZERO:
		idle()
	else:
		if active_state != walk_state:
			activate_state(walk_state)
		velocity = direction.normalized() * speed

func navigate_to(point: Vector2) -> void:
	# TODO: Debounce
	$NavigationAgent2D.target_position = point
	var direction = (
		$NavigationAgent2D.get_next_path_position() - global_position
	).normalized()
	# This is only called for AI,
	# so it's safe to assume we can turn the direction we are going
	facing_direction = direction
	walk()

func host_strike() -> void:
	velocity = Vector2.ZERO
	activate_state(host_strike_state)

func sword_toss() -> void:
	unpossess()
	
	var sword = load("res://player/projectile_sword/projectile_sword.tscn").instantiate()
	sword.rotation = facing_direction.angle()
	sword.position = position + facing_direction * 50
	sword.previous_host = self
	get_parent().add_child(sword)

func sword_swing() -> void:
	velocity = Vector2.ZERO
	activate_state(sword_swing_state)

func force_movement(initial_movement: Vector2, duration: float) -> void:
	forced_movement = initial_movement
	$MovementTimer.start(duration)

func take_damage(amount: int, impact_point: Vector2) -> void:
	health -= amount
	var movement = (position - impact_point).normalized() * 500 * amount
	var hit_duration = 0.2 * amount
	force_movement(movement, hit_duration)
	$HitTimer.start(hit_duration)
	if health <= 0:
		die()

func die() -> void:
	queue_free()

func possess() -> void:
	controller = PlayerController
	controller.bind(self)
	player_controlled = true

func unpossess() -> void:
	controller = ai
	player_controlled = false

func activate_state(incoming: State) -> void:
	if active_state:
		# Should be true except for initial activation
		active_state.on_exit()

	active_state = incoming

	incoming.on_enter()
	var animation = get_animation(incoming)
	if animation != "":
		# Non looping animations will return to idle after we're done
		$Sprite.play(animation)
	elif incoming.duration != 0:
		$StateTimer.start(incoming.duration)
