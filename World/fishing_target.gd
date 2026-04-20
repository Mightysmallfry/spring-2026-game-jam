extends Sprite2D

var _tween: Tween = null

func _ready() -> void:
	visible = false
	var fishing_game = get_parent().get_parent()
	if fishing_game == null:
		push_error("Could not find FishingGame node!")
		return
	fishing_game.fish_caught.connect(_on_fishing_game_fish_caught)

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
	if (position.x + (direction * move_distance)) > 130.0:
		direction = -1
	elif (position.x + (direction * move_distance)) < -130.0:
		direction = 1

	var target_x = clamp(position.x + (direction * move_distance), -130.0, 130.0)

	_tween.tween_property(self, "position:x", target_x, move_time)
	_tween.tween_callback(_move.bind(fish))

func _on_fishing_game_fish_caught(fish: FishData) -> void:
	print("Signal Received! Pattern: ", fish)
	visible = true
	print(fish.fishMoves)
	_move(fish)
