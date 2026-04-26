# TilemapCollisionBorder.gd
extends TileMapLayer
class_name TileMapTerrainManager

@export var wall_thickness: float = 16.0

var _boundary_body: StaticBody2D

const DIRECTIONS: Array[Vector2i] = [
	Vector2i(1, 0), Vector2i(-1, 0),
	Vector2i(0, 1), Vector2i(0, -1),
	Vector2i(1, -1), Vector2i(-1, 1),
	Vector2i(1, 1), Vector2i(-1, -1),
]

func _ready() -> void:
	Global.tile_map_terrain_manager = self
	build()

func rebuild() -> void:
	_cleanup()
	build()

func _cleanup() -> void:
	if _boundary_body == null:
		return
	_boundary_body.free()
	_boundary_body = null

func build() -> void:
	var used_cells: Array[Vector2i] = get_used_cells()
	if used_cells.is_empty():
		return

	var cell_set: Dictionary = {}
	for cell: Vector2i in used_cells:
		cell_set[cell] = true

	var edges: Array[Array] = []
	for cell: Vector2i in used_cells:
		for dir: Vector2i in DIRECTIONS:
			if not cell_set.has(cell + dir):
				var edge: Array[Vector2] = _get_shared_edge(cell, dir)
				if edge.size() == 2:
					edges.append(edge)

	if edges.is_empty():
		return

	_boundary_body = StaticBody2D.new()
	_boundary_body.name = "CollisionBorder"
	_boundary_body.collision_layer = 1
	_boundary_body.collision_mask = 0
	add_child(_boundary_body)

	var merged: Array[Array] = _merge_edges(edges)
	for seg: Array in merged:
		_add_wall(seg[0] as Vector2, seg[1] as Vector2)

func _get_shared_edge(cell: Vector2i, dir: Vector2i) -> Array[Vector2]:
	var cx: float = map_to_local(cell).x
	var cy: float = map_to_local(cell).y
	var origin: Vector2 = map_to_local(Vector2i(0, 0))
	var step_x: float = map_to_local(Vector2i(1, 0)).x - origin.x
	var step_y: float = map_to_local(Vector2i(0, 1)).y - origin.y
	var hw: float = abs(step_x) / 2.0
	var hh: float = abs(step_y) / 2.0

	var top:   Vector2 = Vector2(cx,      cy - hh)
	var right: Vector2 = Vector2(cx + hw, cy)
	var bot:   Vector2 = Vector2(cx,      cy + hh)
	var left:  Vector2 = Vector2(cx - hw, cy)

	var result: Array[Vector2] = []
	match dir:
		Vector2i(1, 0):  result.assign([right, bot])
		Vector2i(-1, 0): result.assign([left,  top])
		Vector2i(0, 1):  result.assign([bot,   left])
		Vector2i(0, -1): result.assign([top,   right])
	return result

func _merge_edges(edges: Array[Array]) -> Array[Array]:
	var by_dir: Dictionary = {}
	for edge: Array in edges:
		var a: Vector2 = edge[0] as Vector2
		var b: Vector2 = edge[1] as Vector2
		var d: Vector2 = (b - a).normalized()
		var key: Vector2 = Vector2(snappedf(d.x, 0.001), snappedf(d.y, 0.001))
		if not by_dir.has(key):
			by_dir[key] = []
		(by_dir[key] as Array).append(edge)

	var merged: Array[Array] = []
	for dir_key: Vector2 in by_dir:
		var group: Array = by_dir[dir_key] as Array
		group.sort_custom(func(e1: Array, e2: Array) -> bool:
			var a1: Vector2 = e1[0] as Vector2
			var a2: Vector2 = e2[0] as Vector2
			return a1.x < a2.x if abs(dir_key.x) > abs(dir_key.y) \
				   else a1.y < a2.y
		)
		var current: Array = group[0] as Array
		for i: int in range(1, group.size()):
			var next: Array = group[i] as Array
			var current_end: Vector2 = current[1] as Vector2
			var next_start: Vector2 = next[0] as Vector2
			if current_end.is_equal_approx(next_start):
				current = [current[0], next[1]]
			else:
				merged.append(current)
				current = next
		merged.append(current)

	return merged

func _add_wall(a: Vector2, b: Vector2) -> void:
	var mid: Vector2 = (a + b) / 2.0
	var diff: Vector2 = b - a
	var shape: RectangleShape2D = RectangleShape2D.new()
	shape.size = Vector2(diff.length(), wall_thickness)
	var col: CollisionShape2D = CollisionShape2D.new()
	col.shape = shape
	col.position = mid
	col.rotation = diff.angle()
	_boundary_body.add_child(col)
