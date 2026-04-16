extends Resource
class_name FishData

@export var fishName : String
@export var fishModifiers : Array[Enums.FishModifier]
@export var fishRarity : Enums.FishRarity

@export var texture : Texture2D

# 10% variation
@export var length : float
@export var girth : float
@export var weight : float
