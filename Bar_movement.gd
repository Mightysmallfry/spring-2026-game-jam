extends RigidBody2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _input(event: InputEvent) -> void:
	if Input.is_key_pressed(KEY_D): #fix this to just be right input
		apply_impulse(Vector2(500,0))
	if Input.is_key_pressed(KEY_A):
		apply_impulse(Vector2(-500,0))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
