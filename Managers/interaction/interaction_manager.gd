extends Node2D
class_name InteractionManager

@onready var interactionLabel = $InteractLabel

@export var player : CharacterBody2D

const TEXT : String = "[ F ] To Interact"

# Keeps track of all areas we are on
var activeAreas = []
# The area we are closest to and want to display?
var focusedArea

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.interaction_manager = self

func _process(delta: float) -> void:
	# Spin through player, checking the closest
	# interact and making it the focus
	pass

func register_area(area : Area2D) -> void: 
	activeAreas.push_back(area)

func remove_area(area : Area2D) -> void:
	activeAreas.remove(area)

func closest_area(player : CharacterBody2D):
	pass
