extends Node2D
class_name BaseBuilding

@export var buildingSprite : Sprite2D
@export var InteractArea : Area2D
@export var CollisionArea : Area2D

@export var buildingName : String


var MAX_LEVEL : int = 9
var INITIAL_LEVEL : int = 1
var current_level : int = 1

var isUnlocked : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Progression.register_building(self)
	InteractArea.body_entered.connect(_on_interact_area_body_entered)
	InteractArea.body_exited.connect(_on_interact_area_body_exited)

func unlock() -> void:
	isUnlocked = true

func _on_interact_area_body_entered(body: Node2D) -> void:
	print("Body entered")

func _on_interact_area_body_exited(body: Node2D) -> void:
	print("Body exited")
