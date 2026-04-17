extends Node2D
class_name BaseBuilding

@export var buildingSprite : Sprite2D
@export var InteractArea : Area2D
@export var CollisionArea : Area2D

@export var buildingName : String
@onready var popups : Node3D = $Popups

var MAX_LEVEL : int = 9
var INITIAL_LEVEL : int = 1
var current_level : int = 1

var isUnlocked : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Progression.register_building(self)

func unlock() -> void:
	isUnlocked = true


func _on_interact_area_body_entered(body: Node2D) -> void:
	pass # Replace with function body.

func _on_interact_area_body_exited(body: Node2D) -> void:
	pass # Replace with function body.
