extends Node

enum FishRarity { 
	COMMON,
	UNCOMMON,
	RARE,
	LEGENDARY,
	GODLY,
	MYSTERIOUS
}

enum FishModifier{
	DREAM,
	ARID,
	TROPICAL,
	ANGELIC,
	DEMONIC,
	CYBER
}

enum FishMoves{
	BOUNCY, #bounces around the middle ish quite fast
	DROPS, #starts left and whips right then resets
	JUMPS, #starts right and whips left then resets
	HILOW, #Jumps between high and low hovering at high.low for a few seconds
	FAKE, #still then moves one way a bit then the other way a lot
	EASY #classic random
}



func _ready() -> void:
	pass
