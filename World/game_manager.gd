extends Node
class_name GameManager

@onready var world_3d : Node3D = $World_3d
@onready var world_2d : Node = $World_2d/SubViewportContainer/SubViewport
@onready var gui : Control = $Gui

var current_world_3d : Node3D
var current_world_2d : Node2D
var current_gui : Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.game_manager = self
	# current_world_3d = $World_3d/Level_One
	# current_world_3d = $World_3d/Level_Dev
	# current_world_3d = $World_3d/level_3
	
	current_gui = $Gui/MainMenu

func change_3d_scene(next_scene_path : String, delete : bool = true, keep_running : bool = false) -> void:
	await Global.transition_manager.transition_fade_out()
	if (current_world_3d != null):
		if (delete):
			current_world_3d.queue_free()
		elif (keep_running):
			current_world_3d.visible = false
		else:
			world_3d.remove_child(current_world_3d)
	
	Global.transition_manager.transition_fade_in()
	var new_scene = load(next_scene_path).instantiate();
	world_3d.add_child(new_scene)
	current_world_3d = new_scene

func change_2d_scene(next_scene_path : String, delete : bool = true, keep_running : bool = false) -> void:
	await Global.transition_manager.transition_fade_out()
	if (current_world_2d != null):
		if (delete):
			current_world_2d.queue_free()
		elif (keep_running):
			current_world_2d.visible = false
		else:
			world_2d.remove_child(current_world_2d)
			
	Global.transition_manager.transition_fade_in()
	var new_scene = load(next_scene_path).instantiate();
	world_2d.add_child(new_scene)
	current_world_2d = new_scene

func change_gui_scene(next_scene_path : String, delete : bool = true, keep_running : bool = false) -> void:
	await Global.transition_manager.transition_fade_out()
	if (current_gui != null):	
		if (delete):
			current_gui.queue_free()
		elif (keep_running):
			current_gui.visible = false
		else:
			gui.remove_child(current_gui)
	
	Global.transition_manager.transition_fade_in()
	if (next_scene_path != ""):
		var new_scene = load(next_scene_path).instantiate();
		gui.add_child(new_scene)
		current_gui = new_scene
		current_gui.mouse_filter = Control.MOUSE_FILTER_PASS
	
func reload_current_world_3d() -> void:
	if current_world_3d == null:
		return
	
	var scenePath : String = current_world_3d.scene_file_path
	if scenePath.is_empty():
		push_warning("No scene file path was found for current scene")
		return
	
	var parent : Node = current_world_3d.get_parent()
	var index : int= current_world_3d.get_index()
	var transform : Transform3D = current_world_3d.global_transform
	var name : StringName = current_world_3d.name
	current_world_3d.queue_free()
	
	var newScene = load(scenePath).instantiate()
	parent.add_child(newScene)
	parent.move_child(newScene, index)
	
	newScene.global_transform = transform
	newScene.name = name
	
	current_world_3d = newScene
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
