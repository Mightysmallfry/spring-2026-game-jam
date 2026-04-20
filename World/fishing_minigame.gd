extends Node2D

@onready var root_ui: Node2D = $UI_container
@onready var catch_area: Sprite2D = $Fishing_bar_outside/Fishing_target

@export var fish:FishData
var fish_in_bar = false

const BASE_HOOK_WINDOW := 0.6
const BASE_ESCAPE_DRAIN := 22.0
const BASE_PROGRESS_GAIN := 28.0
const DURATION := 5.0
enum STATE { CASTING, BITE, HOOK, PLAY, END}

var _state: STATE = STATE.CASTING
var _elapsed: float = 0.0
var _duration: float =0.0
var _bite_timer: float = 2.0
var _hook_window: float
var _bar_h: float
var _bar_pos: float = 0.0
var _bar_vel: float = 0.0
var _fish_pos: float = 0.5
var _fish_vel: float = 0.0
var _progress_val: float = 0.0
var _fish_seed: float

func _on_target_area_2d_body_entered(body: Node2D) -> void:
	print("ENTERED: ", body.name) # See what is hitting the fish [cite: 5]
	if body.name == "FishBar":
		fish_in_bar = true
		print("LOGIC: FishBar ENTERED. fish_in_bar is now TRUE")

func _on_target_area_2d_body_exited(body: Node2D) -> void:
	print("EXITED: ", body.name) # See if the bar ever actually "leaves" [cite: 5]
	if body.name == "FishBar":
		fish_in_bar = false
		print("LOGIC: FishBar ENTERED. fish_in_bar is now FALSE")

signal fishing_finished(success : bool, fish : FishData)

signal fish_caught(caught : bool, pattern : String) #the pattern is for the movement type from the fish

signal start_catching()

func _on_fish_caught() -> void: #these are debug currently
	print("Fish caught!")

func _on_fish_escaped() -> void: #these are debug currently
	print("Fish got away!")
	
func _ready():
	if not fish:
		push_warning("FishingMinigame requires passing in a fish to play")
		return
func _physics_process(delta: float):
	_elapsed += delta
	_duration += delta
	var failed := false
	
	match _state :
		STATE.CASTING:
			#anim for casting
			_state = STATE.BITE
		STATE.BITE:
			_bite_timer -= delta * 1 #if we want to add rods we just change this to * rod.biteratetimer and pass in rod at the top
			if _bite_timer <= 0.0:
				_hook_fish()
		STATE.HOOK:
			_hook_window -= delta * 1
			if _hook_window <= 0.0:
				_fail("Too slow")
				fish_caught.emit(false,fish.fishMoves)
			else:#added
				fish_caught.emit(true)
		STATE.PLAY:
			print(fish_in_bar)
			start_catching.emit()
			if fish_in_bar:
				_progress_val += BASE_PROGRESS_GAIN * delta
			else:
				_progress_val -= BASE_ESCAPE_DRAIN * delta
			_progress_val = clamp(_progress_val,0.0,100.0)
			%TextureProgressBar.value = _progress_val
			if _progress_val >= 100:
				_on_fish_caught()
				_state = STATE.END
			elif _progress_val <= 0:
				_on_fish_escaped()
				_state = STATE.END
		STATE.END:
			pass
			
func _unhandled_input(event):
	if _state == STATE.HOOK:
		if event.is_action_pressed("ui_accept") or event.is_action_pressed("fish"):
			_on_hook()

func _hook_fish():
	_state = STATE.HOOK
	_hook_window = BASE_HOOK_WINDOW * 1 #replace hook window with rod hook window mult
	
	_flashbang(catch_area, 0.12)
	_engorge_ui(root_ui, 1.05,0.08)
	#add hook sound effect

func _on_hook():
	_state = STATE.PLAY
	# Check if the FishBar is already inside the area
	var bodies = $Fishing_bar_outside/Fishing_target/TargetArea2D.get_overlapping_bodies()
	for body in bodies:
		if body.name == "FishBar":
			fish_in_bar = true
			break # We found it, no need to keep looking
	_progress_val = 20.0 #so you dont insta fail
	_time_stop(0.06)
	_shake(6.0,0.18)

func _fail(_why: String):
	_state = STATE.END
	print("fail : " + _why)
	#play hook fail sfx
	_shake(5.0,0.20)
	await get_tree().create_timer(0.2).timeout
	emit_signal("fishing_finished",false,fish)
	
func _engorge_ui(node: Node, scale_to: float, time: float):
	var t: = create_tween()
	t.tween_property(node, "scale", Vector2.ONE * scale_to, time * .5)
	t.tween_property(node, "scale",Vector2.ONE, time * 0.5)

func _flashbang(node: Sprite2D, duration: float):
	var t: = create_tween()
	t.tween_property(node, "modulate", Color(1,1,1,.4), duration * 0.5)
	t.tween_property(node, "modulate", Color(1,1,1,1), duration * 0.5)

func _shake(intensity: float, duration: float):
	var tween :=  create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	for i in range(8):
		var off: = Vector2(randf_range(-intensity, intensity), randf_range(-intensity,intensity))
		tween.tween_property(root_ui,"position",off,duration/8.0)
	tween.tween_property(root_ui, "position", Vector2.ZERO, 0.06)
	
func _time_stop(seconds: float):
	Engine.time_scale = 0.0
	await get_tree().create_timer(seconds,true,true,true).timeout
	Engine.time_scale = 1.0
