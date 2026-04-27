# WaterBorder.gd
extends Node2D
class_name TileMapManager

@export var water_layer: TileMapLayer
@export var tile_size: Vector2 = Vector2(64, 32)
@onready var player = $"../Player"

var fishMinigamePath : String = "res://World/Scenes/fishing_minigame.tscn"

var border_area: Area2D

const DIRECTIONS = [
	Vector2i(1, 0), Vector2i(-1, 0),
	Vector2i(0, 1), Vector2i(0, -1),
	Vector2i(1, -1), Vector2i(-1, 1),
	Vector2i(1, 1), Vector2i(-1, -1),
]

func _ready() -> void:
	Global.tile_map_manager = self
	_build_border()

func rebuild() -> void:
	print("Rebuilding Water Detection")
	_cleanup()
	_build_border()

func _cleanup() -> void:
	if border_area == null:
		return
	for child in border_area.get_children():
		child.free()  # immediate, not queued

func _add_tile_collider(cell: Vector2i) -> void:
	# map_to_local gives position in the tilemap's local space
	# to_global converts that into world space accounting for its flipped scale
	# to_local then brings it into WaterBorder's own local space
	var tilemap_local: Vector2 = water_layer.map_to_local(cell)
	var world_pos: Vector2 = water_layer.to_global(tilemap_local)
	var local_pos: Vector2 = to_local(world_pos)

	var col := CollisionPolygon2D.new()
	col.polygon = PackedVector2Array([
		Vector2(0, -tile_size.y / 2),
		Vector2(tile_size.x / 2, 0),
		Vector2(0, tile_size.y / 2),
		Vector2(-tile_size.x / 2, 0),
	])
	col.position = local_pos
	border_area.add_child(col)

func _build_border() -> void:
	var water_cells := {}
	for cell in water_layer.get_used_cells():
		water_cells[cell] = true

	var border_cells := {}
	for cell in water_cells:
		for dir in DIRECTIONS:
			var neighbour: Vector2i = cell + dir
			if not water_cells.has(neighbour):
				border_cells[neighbour] = true

	if border_area == null:
		border_area = Area2D.new()
		border_area.name = "WaterBorderArea"
		border_area.collision_layer = 0
		border_area.collision_mask = 2
		border_area.body_entered.connect(_on_player_entered_border)
		border_area.body_exited.connect(_on_player_exited_border)
		add_child(border_area)

	for cell in border_cells:
		_add_tile_collider(cell)

func _on_player_entered_border(body: Node2D) -> void:
	if body.is_in_group("player"):
		Global.interaction_manager.register_interaction(border_area)

func _on_player_exited_border(body: Node2D) -> void:
	if body.is_in_group("player"):
		Global.interaction_manager.remove_interaction(border_area)
		
func interact() -> void:
	print("interacted with water!")
	Global.last_player_location = player.global_position
	Global.player_locked = true
	Global.game_manager.change_gui_scene(fishMinigamePath, false, false)
	
