extends PanelContainer
class_name DebugMenu

@onready var DebugProperties : VBoxContainer = $MarginContainer/DebugProperties

var framesPerSecond : String
var masterSliderValue : float
var musicSliderValue : float
var sfxSliderValue : float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	Global.debug_menu = self

	#add_debug_property("FPS", framesPerSecond)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("debug_menu"):
		visible = !visible


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !visible: return
	# The fps = 1/delta calculation
	framesPerSecond = "%.2f" % (1.0/delta)
	add_property("FPS", framesPerSecond, 0)
	
	# Sound debugging
	masterSliderValue = AudioServer.get_bus_volume_linear(AudioServer.get_bus_index("Master"))
	musicSliderValue = AudioServer.get_bus_volume_linear(AudioServer.get_bus_index("Music"))
	sfxSliderValue = AudioServer.get_bus_volume_linear(AudioServer.get_bus_index("SFX"))
	
	add_property("MasterValue", masterSliderValue, 1)
	add_property("MusicValue", musicSliderValue, 2)
	add_property("sfxValue", sfxSliderValue, 3)
	
# Get the menu then call add property in order to add your custom property
func add_property(title : String, value, order):
	var target
	target = DebugProperties.find_child(title, true, false);
	
	# if no target found create one
	if !target: 
		target = Label.new()
		DebugProperties.add_child(target)
		target.name = title
		target.text = target.name + " : " + str(value)
	elif visible: 
		target.text = title + " : " + str(value)
		DebugProperties.move_child(target, order)
		
