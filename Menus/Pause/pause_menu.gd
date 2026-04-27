extends Control
class_name PauseMenu

@export var blurFrame : ColorRect

func _ready() -> void:
	Global.pause_menu = self
	visible = false
	
# Called when the node enters the scene tree for the first time.
func _process(delta : float) -> void:
	if (Input.is_action_just_pressed("pause") && !Global.game_paused):
		Engine.time_scale = 0
		Global.pause()
		await blur_in()
		visible = true
		
	elif (Input.is_action_just_pressed("pause") && Global.game_paused):
		Engine.time_scale = 1
		Global.pause()
		await blur_out()
		visible = false
		
func _on_quit_button_pressed() -> void:
	get_tree().quit()
	
func _on_resume_button_pressed() -> void:
	Engine.time_scale = 1
	Global.pause()
	await blur_out()
	visible = false

func blur_in():
	print("blurred")
	var tween : Tween = create_tween()
	tween.tween_property(
		blurFrame.material,
		"shader_parameter/lod",
		3.0,
		0.05
	)
	
func blur_out():
	var tween : Tween = create_tween()
	tween.tween_property(
		blurFrame.material,
		"shader_parameter/lod",
		0.0,
		0.05
	)
