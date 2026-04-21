extends Sprite2D

var _tween: Tween = null
var fish_upper_bound = position.x + 130
var fish_lower_bound = position.x - 130

func _ready() -> void:
	visible = false
	position = get_parent().get_parent().position
	fish_upper_bound = position.x + 130
	fish_lower_bound = position.x - 130

func _move(fish: FishData) -> void:
	# Kill any existing tween before making a new one

	if _tween:
		_tween.kill()
	_tween = create_tween()
	var move_distance = 60.0
	var move_time = 0.5

	match fish.fishMoves:
		"Easy":
			move_time = 0.8
		"Bouncey":
			move_distance = 40
			move_time = 0.2
			_tween.set_trans(Tween.TRANS_BOUNCE)

	var direction = [-1, 1].pick_random()
	if (position.x + (direction * move_distance)) > fish_upper_bound:
		direction = -1
	elif (position.x + (direction * move_distance)) < fish_lower_bound:
		direction = 1

	var target_x = clamp(position.x + (direction * move_distance), fish_lower_bound, fish_upper_bound)

	_tween.tween_property(self, "position:x", target_x, move_time)
	_tween.tween_callback(_move.bind(fish))

func _on_fishing_game_fish_caught(fish: FishData) -> void:
	print("Signal Received! Pattern: ", fish)
	visible = true
	print(fish.fishMoves)
	_move(fish)
