extends Control
class_name CuttingBoardDisplay

@onready var statList : VBoxContainer = $VBoxContainer/StatList
@onready var fishOnBlock : TextureRect = $VBoxContainer/ChoppingBlock/FishOnBlock

var statlineScene : PackedScene = preload("res://Minigame/scenes/statline.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	for child in statList.get_children():
		child.queue_free()

func add_stat(statName : String, value) -> void:
	var stat = statList.find_child(statName, true, false);
	
	# if no target found create one
	if !stat: 
		stat = statlineScene.instantiate() as Statline
		statList.add_child(stat)
		stat.name = statName
		stat.statTextBox.text = stat.name + " : " + str(value)
	elif visible: 
		stat.statTextBox.text = statName + " : " + str(value)


func display_fish(currentFish : FishData) -> void:
	fishOnBlock.texture = currentFish.texture
	fishOnBlock.expand_mode = TextureRect.EXPAND_KEEP_SIZE
	
	add_stat("Name", currentFish.fishName)
	add_stat("Rarity", Enums.RARITY_NAMES[currentFish.fishRarity])
	add_stat("Weight", currentFish.weight)
	add_stat("Length", currentFish.length)
	add_stat("Girth", currentFish.girth)
	
	fishOnBlock.modulate.a = 0
	fishOnBlock.scale = Vector2.ZERO
	
	var tween = get_tree().create_tween()
	
	tween.set_parallel(true)
	tween.set_trans(Tween.TRANS_BACK)
	tween.set_ease(Tween.EASE_OUT)
	
	tween.tween_property(fishOnBlock, "scale",Vector2.ONE,0.4)
	tween.tween_property(fishOnBlock, "modulate:a",1.0,0.3)
	
	visible = true
