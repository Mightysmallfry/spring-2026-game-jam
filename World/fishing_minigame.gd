extends Node2D

var fishInBar = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	fishInBar = true



func _on_area_2d_body_exited(body: Node2D) -> void:
	fishInBar = false


func _on_timer_timeout() -> void:
	if fishInBar:
		%TextureProgressBar.value += 5;
	else:
		%TextureProgressBar.value -= 5
	
	if %TextureProgressBar.value >= 100:
		print("fish caught")
