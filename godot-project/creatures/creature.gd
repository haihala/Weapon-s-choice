extends CharacterBody2D
class_name Creature

@export var player_controlled: bool
@export var ai_controller: GDScript
var ai: Controller
var controller: Controller

@export var speed = 100

func _ready():
	ai = ai_controller.new()
	controller = PlayerController if player_controlled else ai
	controller.bind(self)

func _process(_delta: float) -> void:
	controller.control()
	velocity = controller.direction * speed
	move_and_slide()
