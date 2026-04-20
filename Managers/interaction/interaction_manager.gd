extends Node2D

@onready var interactionLabel = $InteractLabel

const TEXT : String = "[ F ] To Interact"

# Keeps track of all areas we are on
var activeAreas : Array = []

# The area we are closest to and want to display
var focusedArea

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func register_area(area : Area2D) -> void: 
	activeAreas.push_back(area)

func remove_area(area : Area2D) -> void:
	var index : int = activeAreas.find(area)
	activeAreas.remove_at(index)
