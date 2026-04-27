extends CharacterBody2D


const SPEED = 150.0

func _ready() -> void:
	if (Global.last_player_location != Vector2.ZERO && Global.last_player_location != null):
		print("swapped location")
		global_position = Global.last_player_location

func _physics_process(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# Normalized so diagonals still travel at the same speed
	var inputDirection := Input.get_vector("left", "right", "up", "down")
	inputDirection.y *= 0.5
	inputDirection = inputDirection.normalized()

	velocity = inputDirection * SPEED

	move_and_slide()
