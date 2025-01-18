extends CharacterBody2D
class_name Creature

@export var player_controlled: bool
@export var ai_controller: GDScript
var ai: Controller
var controller: Controller

@export var speed = 300
@export var health = 2

var hit_knockback: Vector2

func _ready():
	ai = ai_controller.new()
	controller = PlayerController if player_controlled else ai
	controller.bind(self)

func _process(_delta: float) -> void:
	if $HitTimer.is_stopped():
		controller.control()
		velocity = controller.direction * speed
	else:
		# Getting hit
		# This way it slows down over the timer and is normalized 1-0
		velocity = hit_knockback * $HitTimer.time_left / $HitTimer.wait_time
	move_and_slide()

func take_damage(amount: int, impact_point: Vector2) -> void:
	health -= amount
	hit_knockback = (position - impact_point).normalized() * 500 * amount
	$HitTimer.start()
	if health <= 0:
		die()

func die() -> void:
	get_tree().queue_delete(self)
