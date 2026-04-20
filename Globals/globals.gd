extends Node

var game_manager : GameManager		# Manages Game Scenes, really a scene manager
var game_paused : bool = false;

var debug_menu : DebugMenu
var audio_manager : AudioManager
var transition_manager : TransitionManager
var game_viewport_manager : GameViewportManager
var interaction_manager : InteractionManager

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
