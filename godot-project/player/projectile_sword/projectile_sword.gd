extends StaticBody2D

var previous_host: Creature

func _physics_process(delta: float) -> void:
	move_and_collide(10 * Vector2.from_angle(rotation))

func on_collision(body: Node) -> void:
	# Layers should be setup in a way where only possessable things can collide
	if body != previous_host:
		body.possess()
		queue_free()
