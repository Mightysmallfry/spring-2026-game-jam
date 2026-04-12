extends Control

@onready var masterSlider : HSlider = $MarginContainer/VBoxContainer/AudioBlock_Master/SliderMaster
@onready var musicSlider : HSlider = $MarginContainer/VBoxContainer/AudioBlock_Music/SliderMusic
@onready var sfxSlider : HSlider = $MarginContainer/VBoxContainer/AudioBlock_SFX/SliderSFX

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	masterSlider.value = AudioServer.get_bus_volume_linear(AudioServer.get_bus_index("Master"))
	musicSlider.value = AudioServer.get_bus_volume_linear(AudioServer.get_bus_index("Music"))
	sfxSlider.value = AudioServer.get_bus_volume_linear(AudioServer.get_bus_index("SFX"))

func _on_slider_master_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(value))
	
func _on_slider_music_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(value))

func _on_slider_sfx_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear_to_db(value))

func _on_button_main_menu_pressed() -> void:
	Global.game_manager.change_gui_scene("res://Menus/MainMenu/main_menu.tscn", true, false)
