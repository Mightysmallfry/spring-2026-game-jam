extends Sprite2D

func _ready() -> void:
	visible = false

func _move(pattern : String) -> void:
	
	var move_distance = 60.0
	var move_time = 0.5
	var t = create_tween()
	
	match pattern:
		"Easy":
			move_time = 0.8
		"Fake":
			print("fakes out")
		"Hilow":
			print()
		"Jumps":
			print()
		"Drops":
			print()
		"Bouncey":
			move_distance = 40
			move_time = 0.2
			t.set_trans(Tween.TRANS_BOUNCE)
			
	var direction = [-1, 1].pick_random()
	if (position.x + (direction * move_distance)) > 130.0:
		direction = -1
	elif (position.x + (direction * move_distance) < -130.0):
		direction = 1
		
	var target_x = position.x + (direction * move_distance)
	target_x = clamp(target_x, -130.0, 130.0)  # adjust to bar bounds
	
	
	t.tween_property(self, "position:x", target_x, move_time)
	t.tween_callback(_move.bind(pattern))  # loop by calling itself when done


func _on_fishing_game_fish_caught(pattern: String) -> void:
	print("Signal Received! Pattern: ", pattern) # Add this to debug
	visible = true
	_move(pattern)
