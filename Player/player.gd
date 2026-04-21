extends CharacterBody2D


const SPEED = 150.0

func _physics_process(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# Normalized so diagonals still travel at the same speed
	var inputDirection := Input.get_vector("left", "right", "up", "down")
	inputDirection.y *= 0.5
	inputDirection = inputDirection.normalized()

	velocity = inputDirection * SPEED

	move_and_slide()
