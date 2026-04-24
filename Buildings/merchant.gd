extends BaseBuilding


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func interact() -> void:
	
	await Global.transition_manager.transition_fade_out()
	var tileMaps = get_tree().get_nodes_in_group("tile_map_layers")
	for tileMapLayer in tileMaps:
		tileMapLayer.scale.x = -tileMapLayer.scale.x;

	var buildings = get_tree().get_nodes_in_group("buildings")
	for build in buildings:
		build.global_position.x = -build.global_position.x
		build.scale.x = -build.scale.x
	
	var players = get_tree().get_nodes_in_group("player")
	for player in players:
		player.global_position.x = -player.global_position.x;
	Global.transition_manager.transition_fade_in()
	
