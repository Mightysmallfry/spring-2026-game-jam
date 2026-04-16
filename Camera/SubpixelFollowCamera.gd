extends Camera2D

var actual_cam_pos : Vector2
var subpixel_offset : Vector2

@onready var player = $".."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	actual_cam_pos = actual_cam_pos.lerp(player.global_position, delta * 3.0)
	
	subpixel_offset = actual_cam_pos.round() - actual_cam_pos
	
	Global.game_viewport_manager.material.set_shader_parameter("cam_offset", subpixel_offset)
	
	global_position = actual_cam_pos.round()
