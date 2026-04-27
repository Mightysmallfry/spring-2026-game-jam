extends Node2D

#NOTE FOR J-BONE!!!!!
#this emits a signal then hides itself, if you want to fish a new fish you need to call reset_for_new_fish(fish : FISHDATA)
#I dont know how we were thinking of doing this but we could check if the fishing minigame exists and it
#it doesent we create it and if it does we call reset_for_new_fish()
#it should be ready for integration!
var MainGamePath : String = "res://World/Scenes/TestWorld.tscn"
@export var fishingGameMusic : AudioStream
@export var successSong : AudioStream


@onready var root_ui: Node2D = $UI_container
@onready var catch_area: Sprite2D = $Fishing_bar_outside/Fishing_target

@export var fish : FishData
var fish_in_bar = false

const BASE_HOOK_WINDOW := 0.6
const BASE_ESCAPE_DRAIN := 20.0
const BASE_PROGRESS_GAIN := 21.0
const DURATION := 5.0
enum STATE { CASTING, BITE, HOOK, PLAY, END, RESULTS}

var _state: STATE = STATE.CASTING
var _elapsed: float = 0.0
var _duration: float =0.0
var _bite_timer: float = 2.0
var _hook_window: float
var _progress_val: float = 0.0
var _fishing_succeded := false
var _end_screen_shown = false

func _on_target_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "FishBar":
		fish_in_bar = true

func _on_target_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "FishBar":
		fish_in_bar = false

signal fishing_finished(success : bool, fish : FishData)

signal fish_caught(fish : FishData) #the pattern is for the movement type from the fish

func _ready():
	Global.audio_manager.play_music(fishingGameMusic)
	
	if not fish:
		push_warning("FishingMinigame requires passing in a fish to play")
		return
	$Difficulty_manager.dificulty = fish.fishRarity
	
func _physics_process(delta: float):
	_elapsed += delta
	_duration += delta

	
	match _state :
		STATE.CASTING:
			#anim for casting
			_state = STATE.BITE
		STATE.BITE:
			_bite_timer -= delta * 1 #if we want to add rods we just change this to * rod.biteratetimer and pass in rod at the top
			if _bite_timer <= 0.0:
				$UI_container/Hook.visible = true
				
				_hook_fish()
		STATE.HOOK:
			_hook_window -= delta * 1
			_flashbang($UI_container/Hook, _hook_window/4)
			_engorge_ui($UI_container/Hook, 1.05,_hook_window/4)
			_shake($UI_container/Hook,3.0,_hook_window/4)
			#HOOK WINDOW, SHOW TEXT
			if _hook_window <= 0.0:
				$UI_container/Hook.visible = false
				_fail("Too slow")
			elif Input.is_action_just_pressed("fish"):
				$UI_container/Hook.visible = false
				_on_hook()
		STATE.PLAY:
			if fish_in_bar:
				_progress_val += BASE_PROGRESS_GAIN * delta
			else:
				_progress_val -= BASE_ESCAPE_DRAIN * delta
			#upgrade_bar_color
			_progress_val = clamp(_progress_val,0.0,100.0)
			%TextureProgressBar.value = _progress_val
			if _progress_val >= 100:
				_fishing_succeded = true
				_state = STATE.END
			elif _progress_val <= 0:
				_fail("Fish Got Away")
				_fishing_succeded = false
				_state = STATE.END
		STATE.END:
			if not _end_screen_shown:
				_end_screen_shown = true
				_clean_fishing_minigame_for_display()
				if _fishing_succeded:
					var caught = $UI_container/CAUGHT
					caught.visible = true
					# These only trigger once now!
					_shake(caught, 3.0, 0.5)
					_flashbang(caught, 0.5)
					_engorge_ui(caught, 1.1, 0.5)
					await get_tree().create_timer(2.0).timeout
					caught.visible = false
					Global.audio_manager.play_music(successSong)
					await get_tree().create_timer(1.0).timeout
					_display_fish() # Show the fish stats/sprite
					_state = STATE.RESULTS
					
				else:
					var to_Bad = $UI_container/To_Bad
					to_Bad.visible = true
					await get_tree().create_timer(1.0).timeout
					to_Bad.visible = false
					_fail("failed to catch")
					Global.game_manager.change_2d_scene(MainGamePath, false, false)

		STATE.RESULTS: #Show STATS!
			if Input.is_action_just_pressed("fish"):
				fishing_finished.emit(_fishing_succeded,fish)
				#The thing restarts so If you want to reset the game pause it as soon as you get the signal
				_deactivate_game()
				Global.game_manager.change_2d_scene(MainGamePath, false, false)

func _clean_tweens():
	set_physics_process(false)
	set_process(false)
	#kill runaway Tweens
	var active_tweens = get_tree().get_processed_tweens()
	for t in active_tweens:
		if t.is_valid():
			t.kill()
	#queue_free()
	
func _set_visuals_on_restart():
	#Hide End Game UI
	$UI_container/Panel.visible = false
	$UI_container/Hook.visible = false
	$UI_container/ChoppingBlock.visible = false
	$UI_container/CAUGHT.visible = false
	$UI_container/To_Bad.visible = false
	
	#ensuring the root is visible just in case
	root_ui.visible = true
	root_ui.modulate.a = 1.0
	root_ui.scale = Vector2.ONE
	
	#Reset the Fish Sprite
	var fishSprite = $UI_container/PotentialFish
	fishSprite.visible = false
	fishSprite.modulate.a = 0
	fishSprite.scale = Vector2.ZERO
	
	#Show Gameplay UI
	$Fishing_bar_outside.visible = true
	%TextureProgressBar.value = 0.0
	%TextureProgressBar.visible = true
	
func _hook_fish():
	_state = STATE.HOOK
	_hook_window = BASE_HOOK_WINDOW * 1 #replace hook window with rod hook window mult
	_flashbang(catch_area, 0.12)
	_engorge_ui(root_ui, 1.05,0.08)
	#add hook sound effect
	
func take_damage():
	_progress_val -= 15
	_progress_val = clamp(_progress_val,0,100)
	%TextureProgressBar.value = _progress_val

func _on_hook():
	fish_caught.emit(fish)
	_progress_val = 15.0 #so you dont insta fail
	_time_stop(0.06)
	_shake(root_ui,6.0,0.18)
	_state = STATE.PLAY

func _fail(_why: String):
	_state = STATE.END
	print("fail : " + _why)
	#play hook fail sfx
	_shake(root_ui,5.0,0.20)
	$Fishing_bar_outside.visible = false
	$UI_container/TextureProgressBar.visible = false
	fishing_finished.emit(_fishing_succeded,fish)
	#the game should be paused as soon as you get the signl
	#_distroy_game()
	#await get_tree().create_timer(0.2).timeout
	#emit_signal("fishing_finished",false,fish)
	
func _deactivate_game():
	set_physics_process(false)
	self.hide()
	_clean_tweens()
	
func reset_for_new_fish(new_fish_data : FishData):
	_state = STATE.CASTING
	_elapsed = 0.0
	_duration = 0.0
	_bite_timer = 2.0
	_progress_val = 0.0
	_end_screen_shown = false
	fish = new_fish_data
	#Update Difficulty for the new fish!
	$Difficulty_manager.dificulty = fish.fishRarity
	#reset visuals to default
	_set_visuals_on_restart()
	#wake
	set_physics_process(true)
	self.show()
	
func _engorge_ui(node: Node, scale_to: float, time: float):
	var t: = create_tween()
	t.tween_property(node, "scale", Vector2.ONE * scale_to, time * .5)
	t.tween_property(node, "scale",Vector2.ONE, time * 0.5)

func _flashbang(node: CanvasItem, duration: float):
	var t: = create_tween()
	t.tween_property(node, "modulate", Color(1,1,1,.4), duration * 0.5)
	t.tween_property(node, "modulate", Color(1,1,1,1), duration * 0.5)

func _shake(node : Node, intensity: float, duration: float):
	var original_pos = node.position
	var tween :=  create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	
	for i in range(8):
		var off : Vector2 = original_pos + Vector2(randf_range(-intensity, intensity), randf_range(-intensity,intensity))
		tween.tween_property(node,"position",off,duration/8.0)
	tween.tween_property(node, "position", Vector2.ZERO, 0.06)
	
func _time_stop(seconds: float):
	Engine.time_scale = 0.0
	await get_tree().create_timer(seconds,true,true,true).timeout
	Engine.time_scale = 1.0
	
func _clean_fishing_minigame_for_display():
	$Difficulty_manager.stop_spawners()
	for enemy in $Enemies.get_children():
		enemy.queue_free()
	$Fishing_bar_outside.visible = false
	$UI_container/TextureProgressBar.visible = false
	
func _display_fish():
	var fishSprite = $UI_container/PotentialFish
	var choppingblock = $UI_container/ChoppingBlock
	var vbox = $UI_container/Panel/VBoxContainer
	var panel = $UI_container/Panel
	panel.visible = true
	vbox.get_node("Name").text = "Name: " + fish.fishName
	var rarity_name = Enums.FishRarity.keys()[fish.fishRarity]
	vbox.get_node("Rarity").text = "Rarity: " + rarity_name
	
	var display_weight = snapped(fish.weight + randf_range(-1.5, 1.5), 0.01)
	vbox.get_node("Weight").text = "Weight: " + str(display_weight)
	
	var display_girth = snapped(fish.girth + randf_range(-1.5, 1.5), 0.01)
	vbox.get_node("Girth").text = "Girth: " + str(display_girth)
	
	var display_length = snapped(fish.length + randf_range(-1.5, 1.5), 0.01)
	vbox.get_node("Length").text = "Length: " + str(display_length)
	
	_flashbang(vbox,0.5)
	
	fishSprite.texture = fish.texture
	choppingblock.visible = true
	
	fishSprite.visible = true
	fishSprite.modulate.a = 0
	fishSprite.scale = Vector2.ZERO
	
	var tween = get_tree().create_tween()
	
	tween.set_parallel(true)
	tween.set_trans(Tween.TRANS_BACK)
	tween.set_ease(Tween.EASE_OUT)
	
	tween.tween_property(fishSprite, "scale",Vector2.ONE,0.4)
	tween.tween_property(fishSprite, "modulate:a",1.0,0.3)
	
