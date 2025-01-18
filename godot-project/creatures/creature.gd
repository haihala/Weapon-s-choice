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

func _process(_delta: float) -> void:
	if can_act():
		controller.control()
	else:
		# Getting hit
		# This way it slows down over the timer and is normalized 1-0
		velocity = hit_knockback * $HitTimer.time_left / $HitTimer.wait_time
	move_and_slide()
	active_state.on_tick()

func can_act() -> bool:
	return active_state != strike_state and $HitTimer.is_stopped()

func idle() -> void:
	if active_state != idle_state:
		activate_state(idle_state)
		velocity = Vector2.ZERO

func walk(direction: Vector2 = facing_direction) -> void:
	if not can_act():
		return

	if direction == Vector2.ZERO:
		idle()
	else:
		if active_state != walk_state:
			activate_state(walk_state)
		velocity = direction.normalized() * speed

func strike() -> void:
	if can_act():
		activate_state(strike_state)

func take_damage(amount: int, impact_point: Vector2) -> void:
	health -= amount
	hit_knockback = (position - impact_point).normalized() * 500 * amount
	$HitTimer.start()
	if health <= 0:
		die()

func die() -> void:
	queue_free()

func possess() -> void:
	controller = PlayerController
	controller.bind(self)

func unpossess() -> void:
	controller = ai

func activate_state(incoming: State) -> void:
	if active_state:
		# Should be true except for initial activation
		active_state.on_exit()

	active_state = incoming

	incoming.on_enter()
	if incoming.animation != "":
		# Non looping animations will return to idle after we're done
		$Sprite.play(incoming.animation)
	elif incoming.duration != 0:
		print(incoming.duration)
		$StateTimer.start(incoming.duration)
