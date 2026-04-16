extends Node

# Trackers
var totalFishCaught : int = 0

# String BuildingName, IsUnlocked
var BuildingUnlocks : Array = []

# PLAYER GAME RESOURCES
var fish : int
var gold : int
var luxury : int

var wood : int
var wood_processed : int
var wood_enchant : int

var stone : int
var stone_brick : int
var stone_brick_concrete : int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func register_building(building : BaseBuilding) -> void:
	if (!BuildingUnlocks.has(building)):
		BuildingUnlocks.append(building)
