extends Sprite2D

var move_distance = 60.0
var move_time = 0.5

func _ready() -> void:
	_move()

func _move() -> void:
	var direction = [-1, 1].pick_random()
	var target_pos = position
	target_pos.x += direction * move_distance
	target_pos.x = clamp(target_pos.x, -130.0, 130.0)  # adjust to your bar bounds
	
	var t = create_tween()
	t.tween_property(self, "position", target_pos, move_time)
	t.tween_callback(_move)  # loop by calling itself when done
