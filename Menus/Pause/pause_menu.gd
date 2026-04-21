extends Control
class_name PauseMenu


func _ready() -> void:
	Global.pause_menu = self
	visible = false
	
	
# Called when the node enters the scene tree for the first time.
func _process(delta : float) -> void:
	if (Input.is_action_just_pressed("pause")):
		Global.pause()
		
	if (Global.game_paused):
		visible = true
		Engine.time_scale = 0
	else:
		visible = false
		Engine.time_scale = 1
		
func _on_quit_button_pressed() -> void:
	get_tree().quit()
	
func _on_resume_button_pressed() -> void:
	Global.pause()
