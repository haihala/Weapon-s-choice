extends CharacterBody2D
class_name Creature

@export var player_controlled: bool
@export var ai_controller: GDScript
var ai: Controller
var controller: Controller

@export var speed = 300
@export var health = 2

@export var idle_state: State
@export var walk_state: State
@export var strike_state: State
var active_state: State

var hit_knockback: Vector2
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
	else:
		# Getting hit
		# This way it slows down over the timer and is normalized 1-0
		velocity = hit_knockback * $HitTimer.time_left / $HitTimer.wait_time
	move_and_slide()
	active_state.on_tick()
	update_sprite_facing()

func can_act() -> bool:
	return active_state != strike_state and $HitTimer.is_stopped()

func get_animation(state: State = active_state) -> String:
	return state.front_animation if facing_direction.y > 0 else state.back_animation

func update_sprite_facing() -> void:
	$Sprite.flip_h = facing_direction.x < 0
	var animation = get_animation()
	if animation:
		$Sprite.animation = animation

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

func strike() -> void:
	if can_act():
		activate_state(strike_state)

func sword_toss() -> void:
	unpossess()
	
	var sword = load("res://player/projectile_sword/projectile_sword.tscn").instantiate()
	sword.rotation = facing_direction.angle()
	sword.position = position + facing_direction * 50
	sword.previous_host = self
	get_parent().add_child(sword)

func take_damage(amount: int, impact_point: Vector2) -> void:
	print("Taking damage")
	health -= amount
	hit_knockback = (position - impact_point).normalized() * 500 * amount
	$HitTimer.start(0.2*amount)
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
