extends CanvasLayer
class_name TransitionManager

@onready var animationPlayer : AnimationPlayer = $TransitionAnimation

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.transition_manager = self

func transition_fade_out():
	animationPlayer.play("fade_in")
	await animationPlayer.animation_finished

func transition_fade_in():
	animationPlayer.play_backwards("fade_in")
	await animationPlayer.animation_finished
