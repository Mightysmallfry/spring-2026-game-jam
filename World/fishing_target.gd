extends Sprite2D

var move_distance = 60.0
var move_time = 0.5

func _ready() -> void:
	visible = false

func _move(pattern : String) -> void:
	var direction = [-1, 1].pick_random()
	var target_pos = position
	target_pos.x += direction * move_distance
	target_pos.x = clamp(target_pos.x, -130.0, 130.0)  # adjust to bar bounds
	
	var t = create_tween()
	t.tween_property(self, "position", target_pos, move_time)
	t.tween_callback(_move)  # loop by calling itself when done


func _on_fishing_game_fish_caught(caught: bool, pattern : String) -> void:
	if caught:
		visible = true
		_move(pattern)
		
