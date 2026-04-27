extends Node

#Example of how to call in the world
#Lets say the player enters the Cyber area
#var area = Enums.FishModifier.CYBER
#var fish_to_spawn = FishManager.get_random_fish_for_region(area)

#I also included a get_random_fish() which does not care about area

const FISH_DIR : String = "res://Fish/Resources"
var _fish_pool : Array[FishData] = []
var _total_weight : float = 0.0
const RARITY_WEIGHTS = {
	Enums.FishRarity.COMMON: 100,
	Enums.FishRarity.UNCOMMON: 50,
	Enums.FishRarity.RARE: 20,
	Enums.FishRarity.LEGENDARY: 10,
	Enums.FishRarity.GODLY: 5,
	Enums.FishRarity.MYSTERIOUS: 2
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_fish_pool = _load_and_cache_fish(FISH_DIR)
	_calculate_pool_weight()
	print("Fish Data Loaded: ", _fish_pool.size(), "fish ready.")

func _load_and_cache_fish(dirPath : String) -> Array[FishData]:
	#Because we need to access qualities of fish to choose a rondom one, we need to have the fish preloaded.
	#its a relitivly small cost in memory for a good cpu gain expessially becaue the fish are just few Strings and a sprite
	var pool : Array[FishData] = []
	var dir : DirAccess = DirAccess.open(dirPath)
	if dir == null:
		push_error("Could not find correct fish resource directory " + dirPath)
		return pool
	dir.list_dir_begin()
	var filename : String = dir.get_next()
	
	while filename != "":
		if not dir.current_is_dir():
			var full_path = dirPath + "/" + filename
			if filename.ends_with(".remap"):
				full_path = full_path.trim_suffix(".remap")
			if full_path.ends_with(".tres"):
				var resource = load(full_path)
				if resource is FishData:
					pool.append(resource)
		filename = dir.get_next()
	dir.list_dir_end()
	return pool
	
func _calculate_pool_weight():
	_total_weight = 0.0
	for fish in _fish_pool:
		_total_weight += RARITY_WEIGHTS.get(fish.fishRarity,1)
	
func get_random_fish() -> FishData:
	if _fish_pool.is_empty(): return null
	
	var roll = randf() * _total_weight
	var cursor = 0.0
	
	for fish in _fish_pool:
		cursor += RARITY_WEIGHTS.get(fish.fishRarity,1)
		if roll <= cursor:
			return fish
	return _fish_pool.back()
	
func _pick_weighted_fish(sub_pool: Array[FishData]) -> FishData:
	var total_weight = 0.0
	for f in sub_pool:
		total_weight += RARITY_WEIGHTS[f.fishRarity]
	var roll = randf() * total_weight
	var current_sum = 0.0
	
	for fish in sub_pool:
		current_sum += RARITY_WEIGHTS[fish.fishRarity]
		if roll <= current_sum:
			return fish
	return sub_pool.back()
	
func get_random_fish_for_region(target_region : Enums.FishModifier) -> FishData:
	var valid_fish: Array[FishData] = []
	
	for fish in _fish_pool:
		if target_region in fish.fishModifiers:
			valid_fish.append(fish)
		
	if valid_fish.is_empty():
		push_warning("No Fish found for region: ", Enums.FishModifier.keys()[target_region])
		return null
	return _pick_weighted_fish(valid_fish)
