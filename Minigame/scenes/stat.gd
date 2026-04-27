extends RichTextLabel

@export var TYPEWRITER_SPEED: float = 0.035

func _ready() -> void:
	visible_characters = 0

func set_dialog(string: String):
	visible_characters = 0
	text = string
	
	for i in range(string.length()):
		visible_characters += 1
		await get_tree().create_timer(TYPEWRITER_SPEED).timeout
