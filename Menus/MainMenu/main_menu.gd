extends Control

@export var mainMenuMusic : AudioStream
var mainMenuAudioFadeDuration : float = 1.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.audio_manager.play_music(mainMenuMusic, mainMenuAudioFadeDuration)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_start_button_pressed() -> void:
	# If we have audio for the main game we can remove this
	# Since playing different audio will also fade out the current audio
	Global.audio_manager.fade_out()
	print("start pressed")
	Global.game_manager.change_2d_scene("LevelOne")
	Global.game_manager.change_gui_scene("PlayerGui")

func _on_quit_button_pressed() -> void:
	get_tree().quit()

func _on_settings_button_pressed() -> void:
	
	#TODO: Something is wrong with changing scene, beware the debug menu
	Global.game_manager.change_gui_scene("res://Menus/Settings/settings_menu.tscn", false, false)
