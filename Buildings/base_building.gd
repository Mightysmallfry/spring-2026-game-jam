extends Node2D
class_name BaseBuilding

@export var buildingSprite : Sprite2D
@export var interactArea : Area2D
@export var collisionArea : StaticBody2D

@export var buildingName : String

var MAX_LEVEL : int = 9
var INITIAL_LEVEL : int = 1
var current_level : int = 1

var isUnlocked : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Progression.register_building(self)
	interactArea.body_entered.connect(_on_interact_area_body_entered)
	interactArea.body_exited.connect(_on_interact_area_body_exited)

func unlock() -> void:
	isUnlocked = true

func _on_interact_area_body_entered(body: Node2D) -> void:
	#print("Body entered")
	Global.interaction_manager.register_interaction(interactArea)

func _on_interact_area_body_exited(body: Node2D) -> void:
	#print("Body exited")
	Global.interaction_manager.remove_interaction(interactArea)

func interact() -> void:
	# print("Interact Called On " + name)
	pass
