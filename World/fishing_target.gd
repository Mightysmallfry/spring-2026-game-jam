extends Sprite2D

var _tween: Tween = null
var fish_upper_bound = position.x + 130
var fish_lower_bound = position.x - 130
var move_counter : int = 0

func _ready() -> void:
	visible = false
	position = get_parent().get_parent().position
	fish_upper_bound = position.x + 130
	fish_lower_bound = position.x - 130


var is_moving = false

func _move(fish: FishData) -> void:
	# Kill any existing tween before making a new one
	var move_distance = 60.0
	var move_time : float = 0.5
	var target_x = position.x
	var rand_dir = false
	if is_moving: return
	is_moving = true
	if _tween:
		_tween.kill()
	_tween = create_tween()


	match fish.fishMoves:
		"EASY":
			rand_dir = true
			move_time = 0.9
		"BOUNCEY":
			rand_dir = true
			move_distance = 40
			move_time = 0.5
			print(move_time)
			_tween.set_trans(Tween.TRANS_BOUNCE)
		"HILOW":
			rand_dir = false
			target_x = fish_upper_bound if position.x < (fish_lower_bound + fish_upper_bound) / 2 else fish_lower_bound
			_tween.tween_property(self,"position:x",target_x,0.2).set_trans(Tween.TRANS_EXPO)
			_tween.tween_interval(0.5) # sticks on the end for a moment

		"JUMPS":
			rand_dir = false
			if move_counter % 3 == 0 or move_counter % 3 == 1:
				target_x = fish_lower_bound + randi_range(0,20)
				_tween.tween_property(self,"position:x",target_x,0.5).set_trans(Tween.TRANS_SINE)
			else:
				target_x = fish_upper_bound + randi_range(-10,0)
				_tween.tween_property(self,"position:x",target_x,0.15).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
				var recovery_target = (fish_lower_bound+fish_upper_bound) / 2 + randi_range(-10,10)
				_tween.tween_property(self,"position:x",recovery_target,0.5).set_trans(Tween.TRANS_SINE)
			move_counter +=1
			
		"DROPS":
			#go up close to the top then drop then go back up then drop then repete
			rand_dir = false
			if move_counter % 3 == 0 or move_counter % 3 == 1:
				var climb_target = fish_upper_bound + randi_range(-25, 0)
				_tween.tween_property(self,"position:x",climb_target,0.5).set_trans(Tween.TRANS_SINE)

			else:
				var drop_target = fish_lower_bound + randi_range(0,20)
				_tween.tween_property(self,"position:x",drop_target,0.15).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
				var recovery_target = (fish_lower_bound+fish_upper_bound) / 2 + randi_range(-10,10)
				_tween.tween_property(self,"position:x",recovery_target,0.5).set_trans(Tween.TRANS_SINE)
			move_counter +=1
			
		"FAKE":
			var dash_right = position.x < (fish_lower_bound + fish_upper_bound) / 2
			var real_target = fish_upper_bound if dash_right else fish_lower_bound
			var fake_direction = -1 if dash_right else 1
			var fake_target = position.x + (fake_direction * 30)
			if move_counter <= 3:
				rand_dir = true
				move_distance = 20
				move_time = 0.9
				move_counter += 1
			elif 3 < move_counter and move_counter <= 6:
				rand_dir = false
				_tween.tween_property(self, "position:x", fake_target, 0.4).set_trans(Tween.TRANS_SINE) #fake move
				#real move
				_tween.tween_property(self,"position:x",real_target,0.15).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
				move_counter += 1
			else:
				rand_dir = true
				move_distance = 20
				move_time = 0.9
				move_counter = 0
		_:
			print("none match")
			
	if rand_dir == true:
		var direction = [-1, 1].pick_random()
		if (position.x + (direction * move_distance)) > fish_upper_bound:
			direction = -1
		elif (position.x + (direction * move_distance)) < fish_lower_bound:
			direction = 1
		target_x = clamp(position.x + (direction * move_distance), fish_lower_bound, fish_upper_bound)
		_tween.tween_property(self, "position:x", target_x, move_time)

	
	_tween.tween_callback(func(): is_moving = false)
	_tween.tween_callback(_move.bind(fish))

func _on_fishing_game_fish_caught(fish: FishData) -> void:
	print("Signal Received! Pattern: ", fish)
	visible = true
	print(fish.fishMoves)
	_move(fish)
