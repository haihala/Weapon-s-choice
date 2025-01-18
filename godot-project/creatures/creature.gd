extends Node2D

@export var player_controlled: bool
@export var controller: GDScript
var ai_controller: Controller

func _ready() -> void:
	ai_controller = controller.new()

func _process(delta: float) -> void:
	if player_controlled:
		PlayerController.foo()
	else:
		ai_controller.foo()
