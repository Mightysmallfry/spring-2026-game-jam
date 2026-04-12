extends Control

@export var mainMenuMusic : AudioStream
var mainMenuAudioFadeDuration : float = 1.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.audio_manager.play_music(mainMenuMusic, mainMenuAudioFadeDuration)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
