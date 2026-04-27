extends Node2D
class_name InteractionManager

@onready var interactionLabel = $InteractLabel

@export var player : CharacterBody2D

const BASE_TEXT : String = "[ F ] To Interact"

# Keeps track of all areas we are on
# Acts like a sorted queue
var activeInteractions = []
var focusedInteraction
var canInteract : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.interaction_manager = self
	interactionLabel.visible = false

func _process(delta: float) -> void:
	if !activeInteractions.is_empty():
		canInteract = true
		activeInteractions.sort_custom(sort_by_distance_from_player)
		focusedInteraction = activeInteractions[0]
		adjust_focused_interaction()
		
		if (focusedInteraction.get_parent() is not BaseBuilding):
			interactionLabel.visible = false
		else:
			interactionLabel.visible = true
	else:
		canInteract = false
		interactionLabel.visible = false
		
	Global.debug_menu.add_property("CanInteract", canInteract, 10)
	
	# The buildings will work with this interact
	# Fishing will be separate
	if (canInteract && Input.is_action_just_pressed("interact")):
		# print("interacted with " + focusedInteraction.get_parent().name)
		focusedInteraction.get_parent().interact()


func register_interaction(area : Area2D) -> void: 
	activeInteractions.append(area)

func remove_interaction(area : Area2D) -> void:
	activeInteractions.erase(area)
	
func sort_by_distance_from_player(interactionA, interactionB) -> bool:
	var AToPlayer = player.global_position.distance_squared_to(interactionA.global_position)
	var BToPlayer = player.global_position.distance_squared_to(interactionB.global_position)
	return AToPlayer < BToPlayer
	
func adjust_focused_interaction() -> void:
	# How do I want to store the text?
	interactionLabel.text = BASE_TEXT
	interactionLabel.global_position = focusedInteraction.global_position
	interactionLabel.global_position.y -= 80
	interactionLabel.global_position.x -= interactionLabel.size.x/2
