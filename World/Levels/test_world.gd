extends Node2D

@export var levelOneMusic : AudioStream

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.audio_manager.play_music(levelOneMusic)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
