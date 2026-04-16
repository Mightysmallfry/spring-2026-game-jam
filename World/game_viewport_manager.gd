extends SubViewportContainer
class_name GameViewportManager

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.game_viewport_manager = self
