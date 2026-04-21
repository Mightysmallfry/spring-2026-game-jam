extends Node2D

@export var levelOneMusic : Array[AudioStream]
var currentSong : int = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for song in levelOneMusic:
		Global.audio_manager.play_music(song)
		await Global.audio_manager.musicPlayers[Global.audio_manager.currentMusicPlayer].finished

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
