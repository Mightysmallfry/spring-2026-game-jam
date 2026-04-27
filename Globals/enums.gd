extends Node

enum FishRarity { 
	COMMON,
	UNCOMMON,
	RARE,
	LEGENDARY,
	GODLY,
	MYSTERIOUS
}

const RARITY_NAMES = {
	FishRarity.COMMON : "Common",
	FishRarity.UNCOMMON : "Uncommon",
	FishRarity.RARE : "Rare",
	FishRarity.LEGENDARY : "Legendary",
	FishRarity.GODLY : "Godly",
	FishRarity.MYSTERIOUS : "???",
	
}

enum FishModifier{
	DREAM = 1 << 0,    #1
	ARID = 1 << 1,     #2
	TROPICAL = 1 << 2, #4
	ANGELIC = 1 << 3,  #8
	DEMONIC = 1 << 4,  #16
	CYBER = 1 << 5     #32
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
