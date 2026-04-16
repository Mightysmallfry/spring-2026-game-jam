extends CharacterBody2D

@export var speed: float = 300.0

# Set these to match your GrooveJoint2D bounds (length 304, so roughly ±130)
@export var min_x: float = -106.0
@export var max_x: float = 122.0

func _physics_process(delta: float) -> void:
	var direction := 0.0

	if Input.is_action_pressed("ui_right"):
		direction = 1.0
	elif Input.is_action_pressed("ui_left"):
		direction = -1.0

	velocity = Vector2(direction * speed,0)
	move_and_collide(velocity * delta)
	position.x = clamp(position.x, min_x, max_x)
