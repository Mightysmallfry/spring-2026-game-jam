extends TileMapLayer

var offsets = [
	Vector2i(0, -1),
	Vector2i(0, 1),
	Vector2i(1, 0),
	Vector2i(-1, 0)
]

var boundaryAtlasCoord : Vector2i = Vector2i(0, 5)
var mainSource : int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var usedCells = get_used_cells()
	for cell in usedCells:
		for offset in offsets:
			var currentSpot = cell + offset
			if get_cell_source_id(currentSpot) == -1: 
				set_cell(currentSpot, mainSource, boundaryAtlasCoord)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func place_boundary() -> void:
	pass
