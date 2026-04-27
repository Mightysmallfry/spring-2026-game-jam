extends SubViewportContainer
class_name GameViewportManager

@onready var subViewport : SubViewport = $SubViewport

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.game_viewport_manager = self
	
func _input(event):
	if event is InputEventMouse:
		var local_event = make_input_local(event)
		subViewport.push_input(local_event)
